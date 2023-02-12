#####
# Add License
#####

resource "citrixadc_systemfile" "license_upload" {
    filename     = var.adc-license.filename
    filelocation = var.adc-license.filelocation
    filecontent  = var.adc-license.filecontent
}

output "filename" {
  value = var.adc-license.filename
}

output "filelocation" {
  value = var.adc-license.filelocation
}

output "filecontent" {
  value = var.adc-license.filecontent
}

#####
# Save Configuration
#####

resource "citrixadc_nsconfig_save" "license_save" {
    all        = true
    timestamp  = timestamp()

    depends_on = [
        citrixadc_systemfile.license_upload
    ]
}

#####
# Reboot
#####

resource "citrixadc_rebooter" "license_reboot" {
    timestamp            = timestamp()
    warm                 = true
    wait_until_reachable = false

    depends_on           = [
        citrixadc_nsconfig_save.license_save
    ]
}