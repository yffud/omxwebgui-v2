<?php


// Read the contents of the CSV file
// Append a line to the CSV file
// Delete the contents of the CSV file



if (post("csv-append")) {

            // annotation-time-store
            // annotation-file
            // annotation-comment

            Data::setKey("settings","ultrasound_machine","Sonosite SII");

            exec("sudo cp /boot/config_sii.txt /boot/config.txt");
            exec("sudo reboot");

            header("Location: " . View::link("settings") . "?machine-update-done=1");
            die();
}


if (get("csv-read")) {
            Data::setKey("settings","ultrasound_machine","Sonosite SII");

            exec("sudo cp /boot/config_sii.txt /boot/config.txt");
            exec("sudo reboot");

            header("Location: " . View::link("settings") . "?machine-update-done=1");
            die();
}


if (post("csv-delete")) {
            Data::setKey("settings","ultrasound_machine","Sonosite SII");

            exec("sudo cp /boot/config_sii.txt /boot/config.txt");
            exec("sudo reboot");

            header("Location: " . View::link("settings") . "?machine-update-done=1");
            die();
}



$handle = fopen();

fputcvs($handle, $line); # $line is an array of string variables

fclose($handle);



?>
