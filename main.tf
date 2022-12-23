#####
# Add License
#####

resource "citrixadc_systemfile" "license_upload" {
    filename     = var.adc-lic-filename
    filelocation = var.adc-lic-filelocation
    filecontent  = file(var.adc-lic-filecontent)
}

#####
# Save Configuration
#####

resource "citrixadc_nsconfig_save" "license_save" {
    all        = true
    timestamp  = timestamp()

    depends_on           = [
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