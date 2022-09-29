
resource "aws_instance" "servers" {
  # --- the majority of this config is omitted for clarity/brevity

  user_data = templatefile("cloud-init.mime", {
    hostname = "<MYHOST>"
    region   = "us-east-1"
  })

  lifecycle {
    # here we don't want to rebuild if user_data changes
    ignore_changes = [user_data]
  }

  # Other config omitted
}
