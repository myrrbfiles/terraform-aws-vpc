resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # vpc association

  tags = local.igw_final_tags
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    availability_zone = slice(data.aws_availability_zones.available.names,0,2)
    map_public_ip_on_launch = true

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${data.aws_availability_zones.available.names[count.index]}
        },
        var.public_subnet_tags
    )
}


resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    availability_zone = slice(data.aws_availability_zones.available.names,0,2)
    
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private-${data.aws_availability_zones.available.names[count.index]}
        },
        var.private_subnet_tags
    )
}

resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.database_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    availability_zone = slice(data.aws_availability_zones.available.names,0,2)
    
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database-${data.aws_availability_zones.available.names[count.index]}
        },
        var.database_subnet_tags
    )
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    
}



