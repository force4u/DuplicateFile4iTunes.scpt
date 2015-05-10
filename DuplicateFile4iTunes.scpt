(*
DuplicateFile4iTunes ver.1
iTunesで選択中のファイルを
指定したフォルダーにコピー（複製）します。

MacでSonyのWALKMAN等を利用する時に
転送（Content Transfer）を利用する場合に
利用出来ます。
*)




---プロンプトの文言改行が使えます\nを入れます
set theWithPrompt to "ファイルの書出し先(Content Transfer指定先)を\n指定してください" as text
---ファイル選択ダイアログのデフォルトのディレクトリ
set theDirName to "/Users/Shared/Music/WALKMAN" as text
---Content-Transferも同じ参照先に変更する
do shell script "defaults write SONY.Content-Transfer NSNavLastCurrentDirectory -string \"" & theDirName & "\""
---保存先をAppleScript形式に変更する
set theDirName to POSIX file theDirName as alias

---Finderを呼び出す
tell application "Finder"
	---ダイアログを出して選択されたフォルダをコピー先とする
	set aliasExpFolder to (choose folder default location theDirName ¬
		with prompt theWithPrompt ¬
		invisibles true ¬
		with multiple selections allowed without showing package contents) as alias
	---ファインダーの終わり
end tell


---iTunesを呼び出す
tell application "iTunes"
	try
		----選択されているファイルの保存先をリストで取得
		set listSelection to location of selection as list
	on error
		---選択していないとエラーになる
	end try
	---iTunesの終わり
end tell
---取得したリストのファイル数
set numSelectionFile to (count of listSelection) as number
---カウンターリセット
set numCntRep to 0 as number

---リピートのはじまり
repeat numSelectionFile times
	---カウントアップ
	set numCntRep to numCntRep + 1 as number
	---１つづ処理する
	set aliasFile to (item numCntRep of listSelection) as alias
	---ファインダーを呼び出す
	tell application "Finder"
		try
			---ファイルを複製する
			duplicate aliasFile to theDirName
		on error
			---すでに同名がある場合はエラーになる
		end try
		---ファインダーの終わり
	end tell
	---リピートの終わり
end repeat




