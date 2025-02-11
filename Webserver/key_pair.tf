resource "aws_key_pair" "project_key" {
  key_name   = "project_key"
  public_key = file("project_key.pub")
}
