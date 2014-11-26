#!/bin/bash
# Build Script by JosegalRe, based on build script of pac-rom

usage() {
    echo -e ""
    echo -e "${txtbld}Usage:${txtrst}"
    echo -e "  build-cm.sh [options] device"
    echo -e ""
    echo -e "${txtbld}  Options:${txtrst}"
    echo -e "    -c# Cleaning options before build:"
    echo -e "        1 - make clean"
    echo -e "        2 - make clobber"
    echo -e "    -j# Set jobs"
    echo -e "    -l  Write warnings and errors to a log file"
    echo -e "    -o# Select GCC O Level"
    echo -e "        Valid O Levels are"
    echo -e "        1 (Os) or 3 (O3)"
    echo -e "    -r  Reset source tree before build"
    echo -e "    -s  Sync repo before build"
    echo -e "    -v  Verbose build output"
    echo -e ""
    echo -e "${txtbld}  Example:${txtrst}"
    echo -e "    ./build-cm.sh -c1 evita"
    echo -e ""
    exit 1
}

# Get OS (linux/Mac OS)
IS_DARWIN=$(uname -a | grep Darwin)
if [ -n "$IS_DARWIN" ]; then
    CPUS=$(sysctl hw.ncpu | awk '{print $2}')
    DATE=gdate
else
    CPUS=$(grep "^processor" /proc/cpuinfo -c)
    DATE=date
fi

# Colors
grn=$(tput setaf 2)                # green
txtbld=$(tput bold)                # bold
txtrst=$(tput sgr0)                # reset
bldblu=${txtbld}$(tput setaf 4)    # bold blue
bldgrn=${txtbld}$(tput setaf 2)    # bold green
export USE_CCACHE=1

opt_clean=0
opt_jobs="$CPUS"
opt_log=0
opt_olvl=0
opt_reset=0
opt_sync=0
opt_verbose=0

while getopts "c:j:lo:rsv" opt; do
    case "$opt" in
    c) opt_clean="$OPTARG" ;;
    j) opt_jobs="$OPTARG" ;;
    l) opt_log=1 ;;
    o) opt_olvl="$OPTARG" ;;
    r) opt_reset=1 ;;
    s) opt_sync=1 ;;
    v) opt_verbose=1 ;;
    *) usage
    esac
done

shift $((OPTIND-1))
if [ "$#" -ne 1 ]; then
    usage
fi
device="$1"

echo -e ""
echo -e "${grn}Building CyanogenMOD 11${txtrst}"

if [ "$opt_clean" -eq 1 ]; then
    make clean >/dev/null
    echo -e ""
    echo -e "${bldblu}Out is clean${txtrst}"
    echo -e ""
elif [ "$opt_clean" -eq 2 ]; then
    make clobber >/dev/null
    echo -e ""
    echo -e "${bldblu}Out is clobber${txtrst}"
    echo -e ""
fi

# Download prebuilt files
date=$(date '+%d')
if [ -x "vendor/cm/get-prebuilts" -a ! -d "vendor/cm/proprietary" ] || [ "$date" == "01" ] || [ "$date" == "15" ]; then
    echo -e ""
    echo -e "${bldblu}Downloading prebuilts${txtrst}"
    vendor/cm/get-prebuilts
    echo -e ""
fi

# Reset source tree
if [ "$opt_reset" -ne 0 ]; then
    echo -e ""
    echo -e "${bldblu}Resetting source tree and removing all uncommitted changes${txtrst}"
    repo forall -c "git reset --hard HEAD; git clean -qf"
    echo -e ""
fi

# Sync with latest sources
if [ "$opt_sync" -ne 0 ]; then
    echo -e ""
    echo -e "${bldblu}Fetching latest sources${txtrst}"
    repo sync -j"$opt_jobs"
    echo -e ""
fi

# Get time of startup
t1=$($DATE +%s)

# Setup environment
echo -e "${bldblu}Setting up environment${txtrst}"
. build/envsetup.sh

# Remove system folder (this will create a new build.prop with updated build time and date)
rm -f "$OUTDIR/target/product/$device/system/build.prop"
rm -f "$OUTDIR/target/product/$device/system/app/*.odex"
rm -f "$OUTDIR/target/product/$device/system/framework/*.odex"
rm -f "$OUTDIR/target/product/$device/obj/KERNEL_OBJ/.version"

# Lunch device
echo -e ""
echo -e "${bldblu}Lunching device${txtrst}"
lunch "cm_$device-userdebug";
echo -e "${bldblu}Starting compilation${txtrst}"

if [ "$opt_olvl" -eq 1 ]; then
    export TARGET_USE_O_LEVEL_S=true
    echo -e ""
    echo -e "${bldgrn}Using Os Optimization${txtrst}"
    echo -e ""
elif [ "$opt_olvl" -eq 3 ]; then
    export TARGET_USE_O_LEVEL_3=true
    echo -e ""
    echo -e "${bldgrn}Using O3 Optimization${txtrst}"
    echo -e ""
else
    unset TARGET_USE_O_LEVEL_S
    unset TARGET_USE_O_LEVEL_3
    echo -e ""
    echo -e "${bldgrn}Using the default GCC Optimization Level, O2${txtrst}"
    echo -e ""
fi

if [ "$opt_verbose" -ne 0 ]; then
    make -j"$opt_jobs" showcommands bacon
else
    if [ "$opt_log" -ne 0 ]; then
        make -j"$opt_jobs" bacon 2> >(sed -r 's/'"$(echo -e "\033")"'\[[0-9]{1,2}(;([0-9]{1,2})?)?[mK]//g' | tee -a warn.log)
    else
        make -j"$opt_jobs" bacon
    fi
fi
echo -e ""

# Finished? Get Elapsed Time
t2=$($DATE +%s)

tmin=$(( (t2-t1)/60 ))
tsec=$(( (t2-t1)%60 ))

echo -e "${bldgrn}Total time elapsed:${txtrst} ${grn}$tmin minutes $tsec seconds${txtrst}"
