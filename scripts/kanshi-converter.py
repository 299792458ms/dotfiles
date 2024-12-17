#!/usr/bin/env python3

import argparse
import glob
import shlex
import sys
from os import path
from typing import List, Optional

PARSED_FILES = []

###
### BEGIN vendored py-scfg 0.1.2
### https://hg.code.netlandish.com/~petersanchez/py-scfg/rev/1ea25657ae2dc28a5b9688aaf349535f8eb9f599
### SPDX-License-Identifier: BSD-3-Clause
###


def get(directives, name):
    for d in directives:
        if d.name == name:
            return d


def get_all(directives, name):
    results = []
    for d in directives:
        if d.name == name:
            results.append(d)
    return results


class Directive:
    name: str
    params: List[str]
    children: List["Directive"]

    def __init__(self, name, params, children=None):
        self.name = name
        self.params = params
        self.children = children or []

    def __str__(self):
        return f"{self.name}: {self.params}"

    def get(self, name) -> Optional["Directive"]:
        return get(self.children, name)

    def get_all(self, name) -> List["Directive"]:
        return get_all(self.children, name)


class Config:
    directives = None

    def __init__(self, filename):
        self.filename = filename

    def load(self):
        # Let Python raise the exception if there's an issue with filename
        with open(self.filename) as fp:
            directives, closing_brace = self.read_block(fp)
        self.directives = directives

    def read_block(self, fp):
        blocks = []
        closing_brace = False

        for line in fp:
            line = line.strip()
            if line.startswith("#"):
                continue

            words = shlex.split(line)
            if not len(words):
                continue

            if len(words) == 1 and line[-1] == "}":
                closing_brace = True
                break

            if words[-1] == "{" and line[-1] == "{":
                words = words[:-1]

                name = ""
                params = words

                if len(words) > 0:
                    name, params = words[0], words[1:]

                child_block, child_closing_brace = self.read_block(fp)
                if not child_closing_brace:
                    raise ValueError("Unexpected EOF")
                d = Directive(name, params, child_block)
            else:
                d = Directive(words[0], words[1:])

            blocks.append(d)

        return blocks, closing_brace

    def get(self, name) -> Optional[Directive]:
        return get(self.directives, name)

    def get_all(self, name) -> List[Directive]:
        return get_all(self.directives, name)


###
### END vendored py-scfg 0.1.2
###

###
### BEGIN kanshi-converter.py
### SPDX-License-Identifier: MIT
###


def wordexp(word) -> [str]:
    expanded_string = path.expandvars(path.expanduser(word))
    tokens = shlex.split(expanded_string)
    expanded_tokens = []
    for token in tokens:
        expanded_tokens.extend(glob.glob(token) or [token])
    return expanded_tokens


def convert_output_fields(field_name_fn, field_value_fn_fn, fields) -> str:
    out = ""
    while len(fields) > 0:
        field = fields.pop(0)
        field_name = field_name_fn(field)
        field_value_fn = field_value_fn_fn(fields, field)
        if field_name == "enable":
            out += "enable = true\n"
        elif field_name == "disable":
            out += "enable = false\n"
        elif field_name == "mode":
            mode = field_value_fn()
            custom = ""
            if mode == "--custom":
                custom = "!"
                mode = field_value_fn()
            out += f'mode = "{custom}{mode}"\n'
        elif field_name == "position":
            position = field_value_fn()
            out += f"{position = }\n"
        elif field_name == "scale":
            scale = field_value_fn()
            out += f"scale = {scale}\n"
        elif field_name == "transform":
            transform = field_value_fn()
            out += f"{transform = }\n"
        elif field_name == "adaptive_sync":
            adaptive_sync = 'true' if field_value_fn() == 'on' else 'false'
            out += f"adaptive_sync = {adaptive_sync}\n"
        else:
            print(f"unknown field {field_name}", file=sys.stderr)

    return out


def convert_output_params(params) -> str:
    return convert_output_fields(
        lambda param: param,
        lambda params, _: lambda: params.pop(0),
        params,
    )


def convert_output_children(children) -> str:
    return convert_output_fields(
        lambda child: child.name,
        lambda _, child: lambda: child.params.pop(0),
        children,
    )


def convert_output(output) -> str:
    assert output.name == "output"
    out = "\n[[profile.output]]\n"

    search = output.params.pop(0)
    # replace wildcard with regex
    if search == "*":
        out += 'search = "/.*"\n'
    else:
        out += f"{search = }\n"

    out += convert_output_params(output.params)
    # output block directive
    out += convert_output_children(output.children)

    return out


def convert_include(directive) -> str:
    assert directive.name == "include"
    out = "\n"
    for file in wordexp(directive.params[0]):
        if file not in PARSED_FILES:
            PARSED_FILES.append(file)
            inner_cfg = Config(file)
            out += convert(inner_cfg)
    return out


def convert_profile(profile) -> str:
    assert profile.name == "profile"
    out = "[[profile]]\n"
    out += f'name = "{profile.params[0]}"\n'

    execs = [" ".join(exec.params) for exec in profile.get_all("exec")]
    if len(execs) > 0:
        out += "exec = [\n"
        for exec in execs:
            out += f'  "{exec}",\n'
        out += "]\n"

    for output in profile.get_all("output"):
        out += convert_output(output)
    out += "\n\n"
    return out


def convert(cfg) -> str:
    cfg.load()
    out = ""
    for directive in cfg.directives:
        if directive.name == "include":
            out += convert_include(directive)
        if directive.name == "profile":
            out += convert_profile(directive)

    return out


def main(src: str, dst: str | None):
    kanshi_in = Config(src)
    shikane_out = convert(kanshi_in).strip()

    if dst is None:
        print(shikane_out)
    else:
        with open(dst, "w") as file:
            file.write(shikane_out)


if __name__ == "__main__":
    desc = """\
    convert kanshi scfg config to shikane toml config

    writes to stdout if destination is unspecified"""
    parser = argparse.ArgumentParser(
        description=desc, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("source", metavar="SOURCE", help="kanshi config file path")
    parser.add_argument(
        "--destination",
        "-d",
        metavar="PATH",
        help="new shikane config file (contents will be overwritten)",
    )
    args = parser.parse_args()

    main(args.source, args.destination)
