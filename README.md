# Untilet

#流れ

1. Yunからテザリング回線を通じてM2X APIに2sおきにデータがプッシュされる。
2. ボタン操作したとき
3. APIにたまったJSON データをalamofireで通信処理(JsonファイルをJsonDataとする)
  -使うライブラリAlamofire
  -処理するデータはAPIのURL
  -返り値はJSONファイルとする
  -この関数をfunc_load()とする
4. JSONデータをJSONパーサー unboxあるいはswifty jsonでパース処理(このあたいをval(int型とする）） 
  -使うライブラリはUnbox
  -処理するデータはJSONファイル
  -引数は3の返り値jsonファイル
  -返り値はval
  -関数名はJson_parser()とする。
#機能

1. パーセント表示
2. ロードボタン
3. 視覚的なデザインにする
4.　通知機能
