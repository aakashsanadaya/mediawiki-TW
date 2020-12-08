resource "aws_instance" "ec2" {

  count                  = var.instance_count

  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = var.user_data
  subnet_id              = var.subnet_id                   
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

    tags = {
    Name = "${var.tags}-${count.index +1}"
  }
}


 resource "null_resource" "ec2" {
   depends_on = ["aws_instance.ec2"]
   count = var.instance_count 
  provisioner "local-exec" {

    command = "echo '${join("\n", formatlist("instance=%v ; private=%v ; public=%v", aws_instance.ec2.*.id, aws_instance.ec2.*.private_ip, aws_instance.ec2.*.public_ip))}' | awk '{print \"node=${var.tags}-${count.index +1}\" NR-1 \" ; \" $0}' >> ./private_ip.txt" 
    }
}

