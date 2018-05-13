import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;

// オーディオ入力の変数を用意する
AudioInput in;

// FFTの変数を用意する
FFT fft;

// プログラム開始時の事前準備
void setup()
{
  // キャンバスサイズの指定
  size(1000, 1000);
  
  // Minim の初期化
  minim = new Minim(this);

  // ステレオオーディオ入力を取得
  in = minim.getLineIn(Minim.STEREO, 512);

  // ステレオオーディオ入力を FFT と関連づける
  fft = new FFT(in.bufferSize(), in.sampleRate());
  // 窓関数の指定
  fft.window(FFT.BLACKMAN);
  
  // 色モードをHSBに
  colorMode(HSB, 360, 100, 100);
}

PVector old_point = new PVector(0, height);

// 描画内容を定める
void draw()
{
  // 背景色を黒に設定
  background(0);
  
  // 線の色を白に設定
  stroke(255);

  // FFT 実行
  fft.forward(in.mix);

  float size = fft.specSize();
  println("size = " + size);
  
  int offset = 50;
  // 棒グラフの描画
  for (int i = 0; i < size; i++)
  {
    if(i % 1 == 0){
      float l = map( 20 * log(fft.getBand(i))+ 1, -200, 100, 0, height/2);
      //float l = fft.getBand(i)*20;
      if(l < offset) l = offset;
      //float point_angle = radians(i * 360.0 / size - 90);
      float point_angle = radians( log( map((float)i / (float)size, 0.0, 1.0, 1.0, 2.71828182846) ) * 360.0 - 90 );
      float x = width/2.0 + (l+offset) * cos(point_angle);
      float y = height/2.0 + (l+offset) * sin(point_angle);
      if( i != 0) {
        stroke( 360.0/size*i, 100, 100);  // 色
        strokeWeight( 2 );
        line(old_point.x, old_point.y, x, y);
        //line(width/2.0, height/2.0, x, y);
      }
      //else println("raw = " + fft.getBand(i) + ", \tlog = " + 20*log(fft.getBand(i)) + ", \tl = " + l);
      old_point.x = x;
      old_point.y = y;
    }
  }
}

// プログラム終了時の処理を定める
void stop()
{
  minim.stop();
  super.stop();
}