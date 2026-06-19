# 运行与导出说明

## 预览 / 渲染

在 OpenSCAD GUI 中打开 `.scad` 文件：

- `F5`：快速预览
- `F6`：完整渲染
- `File → Export`：导出 STL/3MF/DXF 等格式

## 命令行导出

```bash
# 导出 STL
openscad -o exports/nameplate.stl tutorial/basic/06_nameplate.scad

# 导出 PNG 预览
openscad -o exports/nameplate.png tutorial/basic/06_nameplate.scad
```

建议把导出文件放到 `exports/`，该目录已被 `.gitignore` 忽略。

## 参数化模型

多数示例在文件顶部提供参数，例如尺寸、公差、分辨率、装配模式等。修改参数后重新预览/渲染即可。

## 3D 打印建议

- FDM 常用配合间隙：0.2–0.4 mm
- 螺纹/卡扣件建议先打印小样件测试
- 需要高强度的零件优先考虑打印方向与层间受力
