# Linux Command Line Practical Task

## Project Description

This repository is a GitHub-ready workflow for the **Linux Command Line Practical Task**. It is based strictly on the uploaded activity document and is designed to guide the practical work in Kali Linux as the newly created user `student01`.

## Objective

Demonstrate understanding of basic Linux commands by completing the required tasks as a newly created user in Kali Linux.

## Lab Requirements

The activity requires you to:

- Create and switch to a new user named `student01`.
- Set the user's password and add the user to the sudo group if required.
- Confirm the active user with `whoami`.
- Create the required `project` directory structure.
- Create and edit the required files.
- Copy, move, rename, and delete files as specified.
- Apply the required permissions with `chmod`.
- Create the `backup` directory and copy the contents of `docs` and `scripts` into it.
- Verify the final structure and permissions using `tree project` and `ls -la`.
- Optionally record command history in `commands_used.txt`.

## Technologies / Tools

- Kali Linux
- Linux terminal
- `useradd`
- `passwd`
- `usermod`
- `su`
- `whoami`
- `mkdir`
- `cd`
- `echo`
- `ls`
- `nano`
- `cp`
- `mv`
- `chmod`
- `rm`
- `tree`
- `history`
- shell redirection (`>`)

## Prerequisites

- Kali Linux terminal access.
- Permission to create a local user and, where required, use `sudo`.
- Ability to enter the password created for `student01`.

## Important Source Requirements

The task explicitly requires the username `student01`, directory `project`, subdirectories `docs`, `scripts`, and `bin`, and the named files used throughout the activity. These names should not be changed during the practical.

## Step-by-Step Workflow

See [`workflow/workflow.md`](workflow/workflow.md) for the complete procedure, including commands, expected results, verification, and evidence to capture.

## Project Structure

```text
linux-command-line-practical-task/
├── README.md
├── .gitignore
├── docs/
│   ├── README.md
│   └── task-overview.md
├── workflow/
│   ├── README.md
│   └── workflow.md
├── commands/
│   ├── README.md
│   └── commands.sh
├── evidence/
│   ├── README.md
│   ├── screenshots/
│   │   └── .gitkeep
│   └── terminal-output/
│       └── .gitkeep
└── submission/
    ├── README.md
    ├── command-history.txt
    └── final-output.txt
```

## Expected Final Results

Inside `/home/student01/project`, the required final locations are:

```text
project/
├── backup/
│   ├── docs/
│   │   └── report.txt
│   └── scripts/
│       ├── install.sh
│       └── report.txt
├── bin/
│   └── classified.txt
├── docs/
│   └── report.txt
└── scripts/
    ├── install.sh
    └── report.txt
```

The `admin_notes.txt` file should have been deleted during cleanup. The hidden `.secret.txt` should have been moved and renamed to `bin/classified.txt`.

The exact permission checks should be performed with `ls -la` as required by the task.

## Evidence Requirements

The source task does not prescribe specific screenshot filenames or a specific number of screenshots. Capture clear evidence of the required milestones, especially:

1. `whoami` confirming `student01`.
2. Directory and file creation.
3. `report.txt` after the nano edit.
4. File movement/copying.
5. Permission changes.
6. Final `tree project` output.
7. Final `ls -la` output showing permissions and locations.

Store screenshots in `evidence/screenshots/` and terminal captures/output in `evidence/terminal-output/`.

## Submission Requirements

The source task does not specify a separate submission format beyond completing the practical and performing the final checks. This repository therefore provides a submission area without inventing additional submission requirements.

## Troubleshooting

### `tree` is not installed

The task specifically instructs:

```bash
sudo apt install tree
```

Then run:

```bash
tree project
```

### `sudo` is unavailable for `student01`

Follow the task's instruction to add `student01` to the sudo group **if required**. Perform account administration from an account that has the necessary privileges.

### `su student01` does not work

Confirm that the user was created and that a password was set. Then retry the switch.

### Permission verification

Use:

```bash
ls -la
```

inside the relevant directories and compare the displayed permissions with the permissions requested in the task.

## Safety / Permission Notes

User creation, group membership changes, package installation, and other administrative actions require appropriate privileges. Only perform these commands on your own Kali Linux lab environment or a system where you have explicit authorization.
