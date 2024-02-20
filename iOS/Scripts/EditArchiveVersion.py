import os
import sys
import re


def print_current_version():
    file_path = 'Projects/App/MealGok/Project.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()
        # Extract version information using regular expressions
        short_version_match = re.search(r'"CFBundleShortVersionString": "(\d+\.\d+\.\d+)"', content)
        build_version_match = re.search(r'"CFBundleVersion": "(\d+\.\d+\.\d+)"', content)
        
        if short_version_match and build_version_match:
            current_short_version = short_version_match.group(1)
            current_build_version = build_version_match.group(1)
            print(f"현재 버전은 \n shortVersion {current_short_version} \n buildVersion{current_build_version}")
        else:
            print("버전 정보를 찾을 수 없습니다.")
    except Exception as e:
        print(f"Error modifying the file: {e}")

def set_version(short_version, build_version):
    file_path = 'Projects/App/MealGok/Project.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()

        target_name_index = content.find("""      "BGTaskSchedulerPermittedIdentifiers": "com.maramincho.mealgok",""")
        new_short_version = f"""       "CFBundleShortVersionString": "{short_version}","""
        new_build_version = f"""      "CFBundleVersion": "{build_version}","""
        modified_content = content[:target_name_index] + f"{new_short_version}" + f"{new_build_version}" + content[target_name_index + 2:]

        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            file.write(modified_content)

    except Exception as e:
        print(f"Error modifying the file: {e}")

def check_version_regular_expression(version):
    target_regular_expression = r'^\d+\.\d+\.\d+$'
    if re.match(target_regular_expression, version):
        return True
    else:
        print("주어진 버전 문자열이 지정된 형식에 일치하지 않습니다.")
        return False

if __name__ == "__main__":
    print_current_version()
    short_version = input("shortVersion을 입력하세요: ")
    build_version = input("buildVersion을 입력하세요: ")

    if not check_version_regular_expression(short_version) or not check_version_regular_expression(build_version):
        print("입력한 버전 형식이 올바르지 않습니다. 프로그램을 종료합니다.")
        sys.exit(1)

    set_version(short_version, build_version)
    print("버전이 성공적으로 설정되었습니다.")