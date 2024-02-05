import os
import shutil

# 指定包含 txt 文件的根目录
root_directory = 'D:\Programfiles\Myscvp\SC_label_data'

# 使用 os.walk 遍历根目录下的所有子目录和文件
for subdir, dirs, files in os.walk(root_directory):
    for filename in files:
        if filename.endswith('.txt'):  # 确保处理的是 txt 文件
            # 提取文件名（不包含扩展名）并分割
            base_name = os.path.splitext(filename)[0]
            # 移除第一个下划线之前的部分，保留之后的部分作为文件夹名
            folder_name = '_'.join(base_name.split('_')[1:])

            # 创建新的文件夹路径
            new_folder_path = os.path.join(subdir, folder_name)

            # 如果文件夹不存在，则创建它
            if not os.path.exists(new_folder_path):
                os.makedirs(new_folder_path)

            # 构建原始文件的完整路径
            original_file_path = os.path.join(subdir, filename)

            # 构建新的文件路径
            new_file_path = os.path.join(new_folder_path, filename)

            # 将文件移动到新的文件夹
            shutil.move(original_file_path, new_file_path)
