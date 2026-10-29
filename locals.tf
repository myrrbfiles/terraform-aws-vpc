locals {
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "True"
    }

    vpc_final_tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-vpc"
        },
        var.vpc_tags
    )

    igw_final_tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-igw"
        },
        var.igw_tags 
    )
}