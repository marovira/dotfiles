#!/usr/bin/env python

import argparse
import json
import os
import pathlib
import subprocess


def execute_command(proc_name: str, args: list[str]) -> None:
    try:
        env = os.environ.copy()
        subprocess.run(args, check=True, env=env)
    except subprocess.CalledProcessError as exc:
        raise RuntimeError(f"{proc_name} finished with non-zero exit code") from exc


def generate_sample() -> None:
    out_file = pathlib.Path.cwd() / "sample.json"

    entries: list[dict[str, str]] = []
    entries.append({"port": "localhost:16066:localhost:6006", "host": "foo@bar"})

    with out_file.open("w", encoding="utf-8", newline="\n") as outfile:
        json.dump(entries, outfile, indent=4)


def start_ssh_listeners(config: pathlib.Path) -> None:
    with config.open("r", encoding="utf-8") as infile:
        entries = json.load(infile)

    proc_name = "ssh"
    base_args = [proc_name, "-N", "-f", "-L"]
    for entry in entries:
        args = base_args.copy()
        args.append(entry["port"])
        args.append(entry["host"])

        execute_command(proc_name, args)


def main():
    parser = argparse.ArgumentParser(
        description="Start a set of ssh processes to listen at specific ports"
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-i",
        "--input",
        metavar="INPUT",
        nargs=1,
        type=str,
        help="Path to the JSON file to use",
    )
    group.add_argument(
        "-g", "--generate", action="store_true", help="Generate a sample JSON table"
    )

    args = parser.parse_args()

    if args.input:
        config = pathlib.Path(args.input[0]).resolve()
        start_ssh_listeners(config)
    elif args.generate:
        generate_sample()


if __name__ == "__main__":
    main()
