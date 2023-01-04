#####
# Add License
#####

resource "citrixadc_systemfile" "license_upload" {
    filename     = var.adc-base-license.filename
    filelocation = var.adc-base-license.filelocation
    filecontent  = file(var.adc-base-license.filecontent)
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