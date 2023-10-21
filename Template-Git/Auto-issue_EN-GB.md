## Auto-issue
[TOCM]
[TOC]

### Language used

YARM (yml)

-------------

### Project description

add an automatic action in github so that each new issue is added to the project (backlog)

-------------

### Credit , participant, organisation

- Managed by the Unionrolistes development team
- List of contributors Credit.md
- License.md

-------------
### Project goal / target audience

in github, when a task arrives in a backlog, it is possible to configure automatic workflows to assign status to it, but not to add each issue to the backlog.

-------------

### Installation
#### Have a correctly configured organisation
##### Team
- with reviewers
- with writers
##### repository
- labels bug, documetnation, duplicate, enhancement etc
##### projects
enable projects for organisation

##### dependency graph and bot
- security managers , add review and write
- (which will allow your team to manage security concerns)

#### Token
(must switch to your personal account, must be owner)
https://github.com/settings/personal-access-tokens/new
- name it, expiration 90 days or more
- resources owner => organisation
#### acces=> all repos
- permition
- action RW
- issues RW
- workflow RW

#### Organisation access
Projects RW

**UPDATE**
- copy token

#### Personal acces tokens
your token should be in "active token".

#### Secret , action
- create a new one
- name it (TEST for my part)
- and paste the token into it then save.


#### Have a project open in this organisation
##### Model used by the UR
https://github.com/orgs/UnionRolistes/projects/2
- (top right "use this template")

##### Project workflow
- item added to project => "new
- item closed => "ready-prod
- and activate it at the top right

#### add the various repositories
remember to protect the main branch and activate the exits for all.

#### Add the yml
- go to `/.github/workflows/`
- create an "Add-issue-to-project.yml" file
- with the following content
```yml
name: Add-issue-to-project

on:
  issues:
    types:
      - opened

jobs:
  add-to-project:
    name: Add issue to project
    runs-on: ubuntu-latest
    steps:
      - uses: actions/add-to-project@v0.5.0
        with:
          # You can target a project in a different organization
          # to the issue
          project-url: https://github.com/orgs/UnionRolistes/projects/1/views/1
          github-token: ${{ secrets.TEST }}
```
- modify lines 17 and 18 with your own info
- in my case my secret action is called "TEST
- make your commit / PR

-------------

### Update
#### Line 13 modify 0.5.0! by the new version

-------------
### Usage
#### .
---

---
### how to contribute
-------------
