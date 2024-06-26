variable "TEST_RUN_ID" {
  default = "detached"
}

variable "BRANCH" {
  description = "Branch name or pull request for tagging purposes"
  default     = "unknown-branch"
}

variable "BUILD_ID" {
  description = "Build ID in the CI for tagging purposes"
  default     = "unknown-build"
}

variable "CREATED_DATE" {
  description = "Creation date in epoch time for tagging purposes"
  default     = "unknown-date"
}

variable "ENVIRONMENT" {
  default = "unknown-environment"
}

variable "REPO" {
  default = "unknown-repo-name"
}

variable "bucket_name" {
  default = "elastic-package-aws-logs-bucket"
}

variable "queue_name" {
  default = "elastic-package-aws-logs-queue"
}
