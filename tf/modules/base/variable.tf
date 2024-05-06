variable "name_prefix" {
    type = string
    default = "rg"
}

variable "service_name" {
    type = string
    description = "(Required) Nome da aplicação ou serviço que o resource group servirá"
}

variable "region" {
    type = string
    description = "(Required) Região em que o recurso estará efetuando o deploy"
}

variable "tags" {
    type = map(any)
    default = {}
}