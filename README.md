# CreateCharacterModel

輪郭追跡アルゴリズムを利用して， 文字や画像を図形化していろいろと操作したプログラム集．

実装には， 全てProcessingを使用している．

（画像の輪郭追跡のプログラムでは， 使用画像を削除しているため， 実行には修正が必要）


## EdgingCharacterTest

初期の頃作成した， 文字の輪郭追跡のテストプログラム．

`text()`に設定した文字を図形化する．


## ShapeCharacterModel

基本的な輪郭追跡のソースコード． 他のプログラムはこれを基本にしている．


## ShapeImageModel

文字を表示していたコードを画像に変更して， ShapeCharacterModelと同様に図形化したもの．

画像を図形化する場合は， 処理前に画像を白黒以外の単色で塗りつぶしておく必要がある．

また， 画像は白背景または透過画像を使用する．


## ShowCharacterInFisica

図形化した文字を， Processingの物理演算ライブラリであるFisicaを利用して， ばらばらに崩したプログラム．


## ShowCharacterModel

図形化した文字を， P3Dを利用して3D空間上に， VJ素材のように表示したプログラム．

音声入力の大きさによって， 図形の形が崩れるようになっている．

また，　文字はサブウィンドウのテキストボックスから変更が可能．

複数表示すると動作が非常に重くなる問題を， PGraphicsを利用して， 一度図形を定義したのちに複製することで解消している．


## TransformCharacterModel

図形化した二つの文字を利用して， 周期的に交互に形を変化させたプログラム．

二つの文字の輪郭の点列数をそろえ，　一対一に対応させることで実現した．


## TransformImageModel

TransformCharacterModelの画像版．


## VisibleShapingCharacterModel

文字の輪郭追跡の動作を可視化したプログラム．

for文で回していたところを1フレームごとに実行するように書き換えたもの．


## VisibleShapingImageModel

VisibleShapingCharacterModelと同様で， 画像の輪郭追跡の動作を可視化したプログラム．
