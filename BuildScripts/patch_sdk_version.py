#!/usr/bin/env python3
import sys
import os
import struct
import subprocess

def patch_macho_binary(file_path, target_sdk_major=26, target_sdk_minor=0):
    if not os.path.isfile(file_path):
        return False
        
    with open(file_path, 'rb') as f:
        data = bytearray(f.read())
        
    if len(data) < 32:
        return False
        
    # Check Mach-O 64-bit magic (little endian)
    magic = struct.unpack_from('<I', data, 0)[0]
    if magic != 0xfeedfacf:
        # Check fat/universal binary or 32-bit
        return False
        
    ncmds = struct.unpack_from('<I', data, 16)[0]
    offset = 32 # 64-bit Mach-O header size
    
    target_sdk = (target_sdk_major << 16) | (target_sdk_minor << 8) | 0
    modified = False
    
    for _ in range(ncmds):
        if offset + 8 > len(data):
            break
        cmd, cmdsize = struct.unpack_from('<II', data, offset)
        
        if cmd == 0x32: # LC_BUILD_VERSION
            # struct build_version_command:
            # uint32_t cmd (offset+0)
            # uint32_t cmdsize (offset+4)
            # uint32_t platform (offset+8) -> 1 = iOS
            # uint32_t minos (offset+12)
            # uint32_t sdk (offset+16)
            platform = struct.unpack_from('<I', data, offset + 8)[0]
            current_sdk = struct.unpack_from('<I', data, offset + 16)[0]
            current_major = (current_sdk >> 16) & 0xffff
            current_minor = (current_sdk >> 8) & 0xff
            
            print(f"[Mach-O] Found LC_BUILD_VERSION in {os.path.basename(file_path)}: platform={platform}, sdk={current_major}.{current_minor}")
            struct.pack_into('<I', data, offset + 16, target_sdk)
            modified = True
            print(f"[Mach-O] Patched SDK to {target_sdk_major}.{target_sdk_minor} (0x{target_sdk:08X})")
            
        elif cmd == 0x25: # LC_VERSION_MIN_IPHONEOS
            # struct version_min_command:
            # uint32_t cmd (offset+0)
            # uint32_t cmdsize (offset+4)
            # uint32_t version (offset+8)
            # uint32_t sdk (offset+12)
            current_sdk = struct.unpack_from('<I', data, offset + 12)[0]
            current_major = (current_sdk >> 16) & 0xffff
            current_minor = (current_sdk >> 8) & 0xff
            print(f"[Mach-O] Found LC_VERSION_MIN_IPHONEOS in {os.path.basename(file_path)}: sdk={current_major}.{current_minor}")
            struct.pack_into('<I', data, offset + 12, target_sdk)
            modified = True
            print(f"[Mach-O] Patched SDK to {target_sdk_major}.{target_sdk_minor} (0x{target_sdk:08X})")
            
        offset += cmdsize
        
    if modified:
        with open(file_path, 'wb') as f:
            f.write(data)
        print(f"[Mach-O] Successfully saved patched binary: {file_path}")
        return True
    return False

def patch_app_bundle(app_path):
    print(f"Inspecting bundle: {app_path}")
    
    # 1. Patch all binaries inside app bundle
    for root, _, files in os.walk(app_path):
        for fname in files:
            full_path = os.path.join(root, fname)
            try:
                patch_macho_binary(full_path, 26, 0)
            except Exception as e:
                print(f"Error checking {full_path}: {e}")

    # 2. Patch Info.plist files
    info_plist = os.path.join(app_path, "Info.plist")
    if os.path.exists(info_plist):
        cmds = [
            ["/usr/libexec/PlistBuddy", "-c", "Set :DTSDKName iphoneos26.0", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Add :DTSDKName string iphoneos26.0", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Set :DTPlatformVersion 26.0", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Add :DTPlatformVersion string 26.0", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Set :DTXcode 2600", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Add :DTXcode string 2600", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Set :DTXcodeBuild 26A5288g", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Add :DTXcodeBuild string 26A5288g", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Set :DTSDKBuild 26A5288g", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Add :DTSDKBuild string 26A5288g", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Set :BuildMachineOSBuild 24A335", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Add :BuildMachineOSBuild string 24A335", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Set :ITSAppUsesNonExemptEncryption false", info_plist],
            ["/usr/libexec/PlistBuddy", "-c", "Add :ITSAppUsesNonExemptEncryption bool false", info_plist]
        ]
        for cmd in cmds:
            subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"[Plist] Patched {info_plist}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: patch_sdk_version.py <path_to_app_or_xcarchive>")
        sys.exit(1)
        
    target = sys.argv[1]
    if target.endswith(".xcarchive"):
        app_dir = os.path.join(target, "Products", "Applications")
        if os.path.isdir(app_dir):
            for app_name in os.listdir(app_dir):
                if app_name.endswith(".app"):
                    patch_app_bundle(os.path.join(app_dir, app_name))
    elif target.endswith(".app"):
        patch_app_bundle(target)
    elif os.path.isdir(target):
        for root, dirs, _ in os.walk(target):
            for d in dirs:
                if d.endswith(".app"):
                    patch_app_bundle(os.path.join(root, d))
