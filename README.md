# TaskManager Smart Contract

A simple task management smart contract for the Stacks blockchain.

## Overview

This Clarity smart contract allows users to:
- Create tasks with a title and assign them to a principal (Stacks address)
- View tasks assigned to them
- Mark their assigned tasks as completed

## Features

- **Task Creation:** Any user can create a new task and assign it to a principal.
- **Task Assignment:** Each task is assigned to a specific principal.
- **Task Completion:** Only the assigned principal can mark a task as completed.
- **Access Control:** Only the assigned user can view or complete their tasks.
- **Unique Task IDs:** Each task is given a unique ID.

## Contract Functions

- `create-task (title, assignee)`: Create a new task and assign it.
- `get-task (id)`: View details of a task (only if you are the assignee).
- `complete-task (id)`: Mark your assigned task as completed.

## Usage

Deploy the contract to the Stacks blockchain using the [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-lang) language tools.

### Example

```clarity
;; Create a new task
(create-task "Write documentation" 'ST1234...')

;; Get a task (only by assignee)
(get-task u0)

;; Complete a task (only by assignee)
(complete-task u0)
```

## Development

- All code is in the `contracts/TaskManager.clar` file.
- Tests and configuration files are marked as vendored in `.gitattributes`.
