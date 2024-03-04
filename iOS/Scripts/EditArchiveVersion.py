import sys
import re
from datetime import datetime


def print_current_version():
    file_path = 'Projects/App/MealGok/Project.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()
        # Extract version information using regular expressions
        short_version_match = re.search(r'"CFBundleShortVersionString": "(\d+\.\d+\.\d+)"', content)
        build_version_match = re.search(r'"CFBundleVersion": "(\d*)"', content)
        
        if short_version_match and build_version_match:
            current_short_version = short_version_match.group(1)
            current_build_version = build_version_match.group(1)
            print(f"현재 버전은 \n shortVersion {current_short_version} \n buildVersion{current_build_version}")
        else:
            print("버전 정보를 찾을 수 없습니다.")
    except Exception as e:
        print(f"Error modifying the file: {e}")

def set_version():
    file_path = 'Projects/App/MealGok/Project.swift'
    try:
        # Read the content of the Swift file
        with open(file_path, 'r') as file:
            content = file.read()

        marketing_target_name_match = re.search(r'"CFBundleShortVersionString": "(\d)+\.(\d)+\.(\d)+"', content)
        if marketing_target_name_match:
            target_name_index = marketing_target_name_match.start()
        else:
            raise ValueError("marketing_target_name_match name not found in file.")
        new_target_marketing_version = f'{marketing_target_name_match.group(1)}.{int(marketing_target_name_match.group(2)) + 1}.{marketing_target_name_match.group(3)}'
        new_marketing_version = f'       "CFBundleShortVersionString": "{new_target_marketing_version}",\n'
        
        
        build_target_name_match = re.search(r'"CFBundleVersion": "(\d*)"', content)
        if build_target_name_match:
            target_name_index = build_target_name_match.start()
        else:
            raise ValueError("Build Target name not found in file.")
        
        today = generate_date_number()
        build_target_index = len(str(today))
        new_build_version = f'      "CFBundleVersion": "{today}{int(build_target_name_match.group(1)[build_target_index:]) + 1}",\n'
        
        modified_content = content[:marketing_target_name_match - 1] + new_marketing_version + new_build_version + content[marketing_target_name_match + 1: ]

        # Write the modified content back to the file
        with open(file_path, 'w') as file:
            file.write(modified_content)

    except Exception as e:
        print(f"Error modifying the file: {e}")

def generate_date_number():
    today = datetime.now()
    date_number = today.strftime("%Y%m%d")
    return int(date_number)

def check_version_regular_expression(version):
    target_regular_expression = r'^\d+\.\d+\.\d+$'
    if re.match(target_regular_expression, version):
        return True
    else:
        print("주어진 버전 문자열이 지정된 형식에 일치하지 않습니다.")
        return False

if __name__ == "__main__":
    print_current_version()

    set_version()