# convetional-commits-checker
Check that all pull request commits are following convetional commits

## The current pattern that is validated
`eg: feat: #0000 - My Message commit`

`#typeCommit: #cardId - #Msg commit`

# How to use
```
name: "Commit Lint"
on:
  pull_request:
    branches:
      - main
      - development
      - staging
    types:
      - opened
      - reopened
      - labeled
      - unlabeled
      - edited
      - synchronize
jobs:
  commit-lint:
    runs-on: ubuntu-latest
    name: Validate all commits
    steps:
      - uses: actions/checkout@v3
        with:
          token: ${{ secrets.PAT }} # your personal access token
          fetch-depth: 0
      - name: Conventional Commits Checker
        uses: ./ # Uses an action in the root directory
        id: commits-check
        with: # do not change the order of params
          target-branch: ${{ github.event.pull_request.base.ref }}  #required
          current-branch: ${{ github.event.pull_request.head.ref }} #required 
```


# Inputs

### target-branch

**Required** Need to get all commits, use always:  `${{ github.event.pull_request.base.ref }}`

### current-branch
**Required** Need to get all commits, use always:  `${{ github.event.pull_request.head.ref }}`