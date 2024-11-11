

##Create The public_ip
resource "azurerm_public_ip" "public_ip" {
  name                = "agentip"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  allocation_method   = "Static"
}
##Create The network_interface
##Network interface cards are virtual network cards that form the link between virtual machines and the virtual network
resource "azurerm_network_interface" "main" {
  name                = "agent-nic"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.AGENT_SUBNET_ID
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  depends_on = [ azurerm_public_ip.public_ip ]
}
##Create The security_group
resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_publicIP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
##Create The Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.AGENT_VM_NAME
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  size                            = var.VM_SIZE
  admin_username                  = var.ADMIN_USERNAME
  admin_password                  = var.ADMIN_PASSWORD
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.main.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

## Install Docker and Configure Self-Hosted Agent
resource "null_resource" "install_docker" {
  provisioner "remote-exec" {
    inline = ["${file("modules/agentvm/script.sh")}"]
    //inline = ["${file("../script.sh")}"]
    //inline = [file("${path.module}/path/to/inline_script.sh")]
    connection {
      type     = "ssh"
      user     = azurerm_linux_virtual_machine.main.admin_username
      password = azurerm_linux_virtual_machine.main.admin_password
      host     = azurerm_public_ip.public_ip.ip_address
      timeout  = "10m"
    }
  }
  depends_on = [ azurerm_public_ip.public_ip, azurerm_linux_virtual_machine.main ]

}
