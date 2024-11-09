Bastion Host: 
A bastion host is a server/ec2 instance whose purpose is to provide access to a private network from an external network, such as the Internet. You first login to bastion host using its public ip and copy the key pair file of private instance to the bastion host and then login to private subnet instance.It acts as a mediator between private subnet and external world. It is also called jump server or jump box.

