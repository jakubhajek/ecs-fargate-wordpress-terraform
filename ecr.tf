resource "aws_ecr_repository" "asa_repo" {
  name = "asa_repo"
}

output "asa_repo" {
  value = "${aws_ecr_repository.asa_repo.repository_url}"
}
