(*
DuplicateFile4iTunes ver.1.1
iTunesで選択中のファイルを
指定したフォルダーにコピー（複製）します。

MacでSonyのWALKMAN等を利用する時に
転送（Content Transfer）を利用する場合に
利用出来ます。
*)

---WALKMAN転送用のファイルコピー先フォルダ名（ここは任意設定項目）
set theDirName to "WALKMAN" as text


---プロンプトの文言改行が使えます\nを入れます
set theWithPrompt to "ファイルの書出し先(Content Transfer指定先)を\n指定してください" as text
---ミュージックフォルダへのパスを取得する
set theSaveDir to path to music folder from user domain

---UNIXパス形式にする
set theDirPath to (POSIX path of ((theSaveDir & theDirName & ":") as text)) as text
---保存先をalias形式に変更する
try
	---保存先フォルダがあるか？　あれば保存先として格納
	set theDirAlias to POSIX file theDirPath as alias
on error
	--エラーの場合はフォルダが無い　そのため　フォルダを作成する
	tell application "Finder"
		make new folder at theSaveDir with properties {name:theDirName}
	end tell
	---フォルダが出来たので　保存先として改めて格納する
	set theDirAlias to POSIX file theDirPath as alias
end try
---Finderを呼び出す
tell application "Finder"
	---ダイアログを出して選択されたフォルダをコピー先とする
	set aliasExpFolder to (choose folder default location theDirPath ¬
		with prompt theWithPrompt ¬
		invisibles true ¬
		with multiple selections allowed without showing package contents) as alias
	---ファインダーの終わり
end tell
---iTunesを呼び出す
tell application "iTunes"
	try
		----選択されているファイルの実体先をリストで取得
		set listSelection to location of selection as list
	on error
		---選択していないとエラーになる
	end try
	---iTunesの終わり
end tell
---取得したリストのファイル数
set numSelectionFile to (count of listSelection) as number
---処理回数カウンターリセット
set numCntRep to 0 as number
---リピートのはじまり
repeat numSelectionFile times
	---カウントアップ
	set numCntRep to numCntRep + 1 as number
	try
		---１つづ処理する
		set aliasFile to (item numCntRep of listSelection) as alias
	on error
		---選択していないとエラーになる
	end try
	
	---ファインダーを呼び出す
	tell application "Finder"
		try
			---ファイルを複製する
			duplicate aliasFile to theDirAlias
		on error
			---すでに同名がある場合はエラーになる
		end try
		---ファインダーの終わり
	end tell
	---リピートの終わり
end repeat


---Finderを呼び出す
tell application "Finder"
	---コピー先を開く
	open aliasExpFolder
	---ファインダーの終わり
end tell


----Content Transferが起動中か調べる
tell application "System Events"
	set theNameOfApp to "Content Transfer"
	set theNameOfProcesses to name of my application theNameOfApp
	set aliasApp to file of (application processes where name is theNameOfProcesses)
end tell

----Content Transferを起動する
if aliasApp is {} then
	
	---Content-Transferの参照先を変更する
	do shell script "defaults write SONY.Content-Transfer NSNavLastCurrentDirectory -string \"" & theDirPath & "\""
	---起動してからフォルダ確認用に開く
	tell application "Finder"
		---"Content Transfer"を開く
		open name of my application "Content Transfer"
	end tell
	
end if


