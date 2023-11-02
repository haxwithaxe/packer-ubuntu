
source "qemu" "ubuntu" {
	boot_command = [
		" <wait>",
		" <wait>",
		" <wait>",
		" <wait>",
		" <wait>",
		"c",
		"<wait>",
		"set gfxpayload=keep",
		"<enter><wait>",
		"linux /casper/vmlinuz quiet<wait>",
		" autoinstall<wait>",
		" ds=nocloud-net<wait>",
		"\\;s=http://<wait>",
		"{{.HTTPIP}}<wait>",
		":{{.HTTPPort}}/<wait>",
		" ---",
		"<enter><wait>",
		"initrd /casper/initrd<wait>",
		"<enter><wait>",
		"boot<enter><wait>"
	]
	boot_wait = "5s"
	cpus = var.cpus
	disk_size = var.disk_size
	disk_compression = true
	headless = var.headless
	vnc_bind_address = "0.0.0.0"
	http_directory = "http"
	iso_checksum = var.iso_checksum
	iso_url = var.iso_url
	memory = var.memory
	output_directory = var.build_directory
	shutdown_command = "echo '${var.user_password}' | sudo -S shutdown -P now"
	ssh_password = var.user_password
	ssh_port = 22
	ssh_timeout = "10000s"
	ssh_username = var.username
	vm_name = var.vm_name
	qemuargs = [
		[ "-m", var.memory ],
		[ "-display", var.qemu_display ]
	]
}

build {

	sources = ["source.qemu.ubuntu"]

    provisioner "shell" {
		environment_vars = [
			"HOME_DIR=/home/${var.username}",
			"http_proxy=${var.http_proxy}",
			"https_proxy=${var.https_proxy}",
			"no_proxy=${var.no_proxy}",
			"ANSIBLE_VAULT_PASSWORD='${var.ansible_vault_password}'"
		]
		execute_command = "echo '${var.user_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
		expect_disconnect = true
		scripts = [
			"${path.root}/scripts/cloud-init.sh",
			"${path.root}/scripts/update.sh",
			"${path.root}/scripts/sshd.sh",
			"${path.root}/scripts/networking.sh",
			"${path.root}/scripts/sudoers.sh",
			"${path.root}/scripts/ansible.sh",
			"${path.root}/scripts/cleanup.sh",
			"${path.root}/scripts/minimize.sh"
		]
	}
}

variables {
	box_basename = "ubuntu-21.04"
	build_directory = env("BUILD_DIR")
	cpus = "2"
	disk_size = "65536"
	git_revision = "__unknown_git_revision__"
	guest_additions_url = ""
	headless = true
	http_proxy = env("http_proxy")
	https_proxy = env("https_proxy")
	iso_checksum = env("ISO_CHECKSUM")
	iso_url = env("ISO_URL")
	memory = "1024"
	no_proxy = env("no_proxy")
	preseed_path = "preseed.cfg"
	qemu_display = "none"
	vm_name = env("IMAGE_NAME")
	version = "TIMESTAMP"
	username = "hax"
	user_password = "toor"
	ansible_vault_password = env("ANSIBLE_VAULT_PASSWORD")
}
