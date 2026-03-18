<p align="center">
    <img src="/assets/images/furMusicNotes.png" alt="logo" width="50%">
</p>

# 毛绒音符
**周周制作的8键音乐游戏**

## 玩法
聆听音乐的节奏消除音符<br />
消除音符按键依次为 A S D F J K L ;<br />
全屏切换 F11<br />
音轨提示 空格<br />
白色是短音 按一次消除<br />
蓝色是长音 按住连续消除<br />
透明紫色是示范音符 自动消除<br />

## 资源文件夹
userdata是资源文件夹<br />
毛绒音符音乐包的结构：
```
packageName 音乐包文件夹
    index.json 包索引
    music1 曲目1
        music.ogg ogg格式音频
        notedata.json 曲谱
        preview.png 预览背景图
    music2 曲目2
    ...
```
将这样的文件夹放入 userdata/musicPackages 下即完成音乐包的导入<br />
