
resource "aws_vpc" "new-vps-terraform" {
  cidr_block = "${var.vpc-cidr}"
  tags {
    Name        = "new vpc terraform"
    environment = "dev"
    location    = "eu-west-1"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.new-vps-terraform.id}"
  tags {
    Name        = "igw"
    environment = "dev"
    location    = "eu-west-1"
  }
}
//resource "aws_nat_gateway" "ngw" {
//allocation_id = "${aws_eip.eip.id}"
// subnet_id = "$aws_subnet.prvate-sub.id}"
///depends_on = ["aws_internet_gateway.igw"]
//}
//resource "aws_eip" "eip" {
//vpc      = true
//depends_on = ["aws_internet_gateway.igw"]
//}
resource "aws_subnet" "public-sub" {
  cidr_block = "${var.pubsub-cidr}"
  vpc_id = "${aws_vpc.new-vps-terraform.id}"
  count = "${var.subnet_count}"
  // availability_zone       = "${data.aws_availability_zones.available.names[0]}"


  tags {
    Name        = "public-subnet"
    environment = "dev"
    location= "eu-west-1a"
  }
}

resource "aws_subnet" "private-sub" {
  cidr_block = "${var.prisub-cidr}"
  vpc_id = "${aws_vpc.new-vps-terraform.id}"
  // availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  count = "${var.subnet_count}"

  tags {
    Name        = "private-subnet"
    environment = "dev"
    location= "eu-west-1a"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.new-vps-terraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name        = "public rtt"
    environment = "dev"
    location= "eu-west-1a"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.new-vps-terraform.id}"

  // route {
  //  cidr_block = "0.0.0.0/0"
  // gateway_id = "${aws_nat_gateway.ngw.id}"
  //}
  tags {
    Name        = "private rtt"
    environment = "dev"
    location= "eu-west-1a"
  }
}
resource "aws_route_table_association" "private-association" {
  count = "${var.subnet_count}"
  route_table_id = "${aws_route_table.private-rt.id}"
  subnet_id = "${element(aws_subnet.private-sub.*.id, count.index )}"
}
resource "aws_route_table_association" "public-association" {
  count = "${var.subnet_count}"
  route_table_id = "${aws_route_table.public-rt.id}"
  subnet_id = "${element(aws_subnet.public-sub.*.id, count.index )}"
}

output "private_subnets" {
  value = ["${aws_subnet.private-sub.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public-sub.*.id}"]
}
