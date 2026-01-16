#!/bin/bash
set -e
pegasus_lite_version_major="5"
pegasus_lite_version_minor="1"
pegasus_lite_version_patch="1"
pegasus_lite_enforce_strict_wp_check="true"
pegasus_lite_version_allow_wp_auto_download="true"
pegasus_metrics="true"


. pegasus-lite-common.sh

pegasus_lite_init

# cleanup in case of failures
trap pegasus_lite_signal_int INT
trap pegasus_lite_signal_term TERM
trap pegasus_lite_unexpected_exit EXIT

printf "\n########################[Pegasus Lite] Setting up workdir ########################\n"  1>&2
# work dir
export pegasus_lite_work_dir=$PWD
pegasus_lite_setup_work_dir

printf "\n##############[Pegasus Lite] Figuring out the worker package to use ##############\n"  1>&2
# figure out the worker package to use
pegasus_lite_worker_package

pegasus_lite_section_start stage_in
printf "\n##################### Checking file integrity for input files #####################\n"  1>&2
# do file integrity checks

pegasus_lite_section_end stage_in
set +e
job_ec=0
pegasus_lite_section_start task_execute
printf "\n######################[Pegasus Lite] Executing the user task ######################\n"  1>&2
pegasus-kickstart  -n plankifier -N ID0000001 -R condorpool  -s predict_unanimityabs0.6.txt=predict_unanimityabs0.6.txt -L plankifier-wf -T 2026-01-16T05:33:47+00:00 /srv/plankifier/predict.py -modelfullnames /srv/plankifier/trained-models/conv2/keras_model.h5 -weightnames /srv/plankifier/trained-models/conv2/bestweights.hdf5 -testdirs /srv/plankifier/camera-images -thresholds 0.6 -ensMethods unanimity -predname ./predict
job_ec=$?
pegasus_lite_section_end task_execute
set -e
pegasus_lite_section_start stage_out
pegasus_lite_section_end stage_out

set -e


# clear the trap, and exit cleanly
trap - EXIT
pegasus_lite_final_exit

