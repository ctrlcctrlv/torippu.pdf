#!/usr/bin/perl
# ２ちゃんねる掲示板風トリップ取得（★コピペの注釈付き版）.pl
# (2ch_tripcode_annotated_ja.pl)
#
# © ２０２０年〜２０２２年 フレドリック　R　ブレンナン
#
# ★ＦＯＸ（中尾嘉宏）の公開ドメインコードを基にしています。
# これも公開ドメインコードである。

# トリップキーを標準入力から取得する
$tripkey = <STDIN>;
chomp $tripkey;
if (substr($tripkey, 0, 1) ne "#") {
  print STDERR "トリップキーは#で始まる必要があります" && exit 1
};
# 「＃」削除化
$tripkey = substr $tripkey, 1;

#*#*# ソルト生成化 #*#*#

# パスワードから２文字目と３文字目をソルトとして使用する。
# 例：「salt」から「st」となる。
$salt = substr $tripkey . "H.", 1, 2;
# アスキー範囲外の文字をすべて０ｘ２Ｅ(ピリオド)に変換する。
$salt =~ s/[^\.-z]/\./g;
# 以下の文字をABCDEFGabcdefに置き換える。
# :;<=>?@[\]^_`
# 例えば、#istripの場合はsaltは"st"のままである。しかし、#:_`の場合はsaltは"ef"になる。
$salt =~ tr/:;<=>?@[\\]^_`/A-Ga-f/;

print STDERR "注: ソルトは $salt\n";

#*#*# トリップコードを生成する #*#*#

# crypt()を実行する。これはＤＥＳベースの一方向ハッシュである。
# このパール版では、トリップキーの最初の８文字（！）のみを考慮する。
$trip = crypt $tripkey, $salt;

if (length($tripkey) > 8) {
    my $extra = substr $tripkey, 8;
    my $err = "警告: パスワードは長すぎ。$extra は無視された、ハッシュ結果でない。\n";
    print STDERR $err;
}

# ハッシュの最後の10文字を取得する
$trip = substr $trip, -10;

# 先頭に◆を付ける。4chanでは!が使われる。
$trip = "◆" . $trip;

# 標準出力に出力する
print STDOUT "トリップ: ", $trip, "\n";

exit 0
