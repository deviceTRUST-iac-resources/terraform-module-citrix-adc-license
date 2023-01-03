#####
# Add License
#####

resource "citrixadc_systemfile" "license_upload" {
    filename     = var.adc-license.filename
    filelocation = var.adc-license.filelocation
    filecontent  = file(var.adc-license.filecontent)
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

#####
# Wait for config save to commence properly, before allowing the subsequent module to run.
#####


resource "time_sleep" "license_wait" {

  create_duration = "5s"

  depends_on = [
    citrixadc_nsconfig_save.license_save
  ]

}