# Version: 0.2.0


#### Changes

* [#3](https://github.com/jivygroup/terraform-aws-vpc-peering/pull/3): Prepares the module for publication


# Version: 0.1.0


#### Changes

* [#1](https://github.com/jivygroup/terraform-aws-vpc-peering/pull/1): Initial work migrating from mp-terraform


# Version: 0.3.0

#### Bug Fixes

- [#2](https://github.com/jivygroup/om2-terraform-gke/pull/2): Fixes auth token for changelog workflow

#### New Features

- [#1](https://github.com/jivygroup/om2-terraform-gke/pull/1): Adds initial GKE platground

#### Changes

- [#3](https://github.com/jivygroup/om2-terraform-gke/pull/3): PR workflow for changelog testing
- [#5](https://github.com/jivygroup/om2-terraform-gke/pull/5): [Changelog CI] Add Changelog for Version 0.2.0
- [#17](https://github.com/jivygroup/om2-terraform-gke/pull/17): [Changelog CI] Add Changelog for Version 0.3.0

# Automation for changelog generation on release

https://github.com/marketplace/actions/changelog-ci

### Usage

1. All the files from .github folder should be copied to the same location in target repository
2. Pipeline is running only on release branch and hotfix branch (changes of changelog.md file are not triggering the pipeline second time)
3. Version is taken from branch name of release (ex. release/0.2.3 the Version in changelog will be 0.2.3)
4. .github/config/config.yaml should be configured accordigly with the project.
   Configuration File options
   These are the options that can be provided on the config_file.

| Name                      | Required | Descriptios                                                                                                                                                                                                                                                             | Default       | Options                        |
| ------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------------------------ |
| changelog_type            | No       | pull_request option will generate changelog using pull request title. commit_message option will generate changelog using commit messages.                                                                                                                              | pull_request  | pull_request or commit_message |
| header_prefix             | No       | The prefix before the version number. e.g. version: in Version: 1.0.2                                                                                                                                                                                                   | Version:      |                                |
| commit_changelog          | No       | If it's set to true then Changelog CI will commit the changes to the release pull request. (A pull Request will be created with the changes if the workflow run is not triggered by a pull_request event)                                                               | true          | true or false                  |
| comment_changelog         | No       | If it's set to true then Changelog CI will comment the generated changelog on the release pull request. (Only applicable for workflow runs triggered by a pull_request event)                                                                                           | false         | true or false                  |
| pull_request_title_regex  | No       | If the pull request title matches with this regex Changelog CI will generate changelog for it. Otherwise, it will skip the changelog generation. (Only applicable for workflow runs triggered by a pull_request event)                                                  | ^(?i:release) |                                |
| version_regex             | No       | This regex is used to find the version name/number (e.g. 1.0.2, v2.0.2) from the pull request title. in case of no match, changelog generation will be skipped. (Only applicable for workflow runs triggered by a pull_request event)                                   | SemVer        |                                |
| group_config              | No       | By adding this you can group changelog items by your repository labels with custom titles.                                                                                                                                                                              | null          |                                |
| include_unlabeled_changes | No       | if set to false the generated changelog will not contain the Pull Requests that are unlabeled or the labels are not on the group_config option. This option will only be used if the group_config option is added and the changelog_type option is set to pull_request. | true          | true or false                  |
| unlabeled_group_title     | No       | This option will set the title of the unlabeled changes. This option will only be used if the include_unlabeled_changes option is set to true, group_config option is added and the changelog_type option is set to pull_request.                                       | Other Changes |                                |
