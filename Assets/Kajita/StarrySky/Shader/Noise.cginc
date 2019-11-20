//関数内で大量に変数を定義するとGPU時間がめちゃ遅くなるのでスコープを使って書き直している部分があるので可読性が少し落ちている。ので注意。
///ret : 0.0 - <1.0
float rand(float n)
{
  return frac(sin(n) * 63452.5453123);
}

///ret : 0.0 - <1.0
float rand(float2 co)
{
  return rand(dot(co.xy, float2(24.8654, 84.657321)));
}

///ret : 0.0 - <1.0
float rand(float3 vec)
{
  return rand(dot(vec, float3(17.864342, 96.25642, 52.753978)));
}


//ret : (0, 0) - <(1, 1)
//2Dランダム
float3 rand3D(float3 vec)
{
  
  float rand1 = dot(vec, float3(127.1, 311.7, 264.7));
  float rand2 = dot(vec, float3(269.5, 183.3, 336.2));
  float rand3 = dot(vec, float3(301.7, 231.1, 142.6));
  
  float3 rand = float3(rand1, rand2, rand3);
  return - 1.0 + 2.0 * frac(sin(rand) * 43758.5453123);
}


///ret : -1 - +1
float2 rand2D(float2 st)
{
  st = float2(dot(st, float2(127.1, 311.7)),
  dot(st, float2(269.5, 183.3)));
  return - 1.0 + 2.0 * frac(sin(st) * 43758.5453123);
}

///Value Noise
///ret : 0.0 - <1.0
float valNoise(float x)
{
  float i = floor(x);
  float f = frac(x);
  
  float rand_0 = rand(i);
  float rand_1 = rand(i + 1.0);
  return lerp(rand_0, rand_1, smoothstep(0.0, 1.0, f));
}

float valNoise(float2 uv)
{
  float2 i = floor(uv);
  float2 f = frac(uv);
  
  float2 sm = smoothstep(0.0, 1.0, f);
  
  //o = origin
  float rand_o = rand(i);
  float rand_x = rand(i + float2(1.0, 0.0));
  float rand_y = rand(i + float2(0.0, 1.0));
  float rand_xy = rand(i + float2(1.0, 1.0));
  
  float value_x0 = lerp(rand_o, rand_x, sm.x);
  float value_x1 = lerp(rand_y, rand_xy, sm.x);
  float value = lerp(value_x0, value_x1, sm.y);
  return value;
}

float valNoise(float3 pos)
{
  float3 i = floor(pos);
  float3 f = frac(pos);
  
  float3 sm = smoothstep(0, 1, f);
  
  float rand_o = rand(i);
  float rand_x = rand(i + float3(1.0, 0.0, 0.0));
  float rand_y = rand(i + float3(0.0, 1.0, 0.0));
  float rand_z = rand(i + float3(0.0, 0.0, 1.0));
  float rand_xy = rand(i + float3(1.0, 1.0, 0.0));
  float rand_xz = rand(i + float3(1.0, 0.0, 1.0));
  float rand_yz = rand(i + float3(0.0, 1.0, 1.0));
  float rand_xyz = rand(i + float3(1.0, 1.0, 1.0));
  
  //底面
  float value_x0 = lerp(rand_o, rand_x, sm.x);
  float value_x1 = lerp(rand_z, rand_xz, sm.x);
  float noiseXZ0 = lerp(value_x0, value_x1, sm.z);
  
  //天井
  float value_x2 = lerp(rand_y, rand_xy, sm.x);
  float value_x3 = lerp(rand_yz, rand_xyz, sm.x);
  float noiseXZ1 = lerp(value_x2, value_x3, sm.z);
  
  float noise = lerp(noiseXZ0, noiseXZ1, sm.y);
  return noise;
}

//Perline Noise

float pNoise(float pos)
{
  return pNoise(float2(pos, 0));
}

float pNoise(float2 pos)
{
  float2 i_o = floor(pos);
  float2 f = frac(pos);
  
  float2 sm = smoothstep(0, 1, f);
  
  float dot_o = 0;
  float dot_x = 0;
  float dot_y = 0;
  float dot_xy = 0;
  {
    float2 i_x = i_o + float2(1, 0);
    float2 i_y = i_o + float2(0, 1);
    float2 i_xy = i_o + float2(1, 1);
    float2 rand_o = rand2D(i_o);
    float2 rand_x = rand2D(i_x);
    float2 rand_y = rand2D(i_y);
    float2 rand_xy = rand2D(i_xy);
    
    float2 toPos_o = pos - i_o;
    float2 toPos_x = pos - i_x;
    float2 toPos_y = pos - i_y;
    float2 toPos_xy = pos - i_xy;
    
    dot_o = dot(rand_o, toPos_o) * 0.5 + 0.5;
    dot_x = dot(rand_x, toPos_x) * 0.5 + 0.5;
    dot_y = dot(rand_y, toPos_y) * 0.5 + 0.5;
    dot_xy = dot(rand_xy, toPos_xy) * 0.5 + 0.5;
  }
  
  float value1 = lerp(dot_o, dot_x, sm.x);
  float value2 = lerp(dot_y, dot_xy, sm.x);
  float value3 = lerp(0, value2 - value1, sm.y);
  return value1 + value3;
}

float pNoise(float3 pos)
{
  float3 i_o = floor(pos);
  float3 f = frac(pos);
  
  float3 sm = smoothstep(0, 1, f);
  
  float dot_o = 0;
  float dot_x = 0;
  float dot_y = 0;
  float dot_z = 0;
  float dot_xy = 0;
  float dot_xz = 0;
  float dot_yz = 0;
  float dot_xyz = 0;
  {
    float3 i_x = i_o + float3(1, 0, 0);
    float3 i_y = i_o + float3(0, 1, 0);
    float3 i_z = i_o + float3(0, 0, 1);
    float3 i_xy = i_o + float3(1, 1, 0);
    float3 i_xz = i_o + float3(1, 0, 1);
    float3 i_yz = i_o + float3(0, 1, 1);
    float3 i_xyz = i_o + float3(1, 1, 1);
    float3 rand_o = rand3D(i_o);
    float3 rand_x = rand3D(i_x);
    float3 rand_y = rand3D(i_y);
    float3 rand_z = rand3D(i_z);
    float3 rand_xy = rand3D(i_xy);
    float3 rand_xz = rand3D(i_xz);
    float3 rand_yz = rand3D(i_yz);
    float3 rand_xyz = rand3D(i_xyz);
    
    float3 toPos_o = pos - i_o;
    float3 toPos_x = pos - i_x;
    float3 toPos_y = pos - i_y;
    float3 toPos_z = pos - i_z;
    float3 toPos_xy = pos - i_xy;
    float3 toPos_xz = pos - i_xz;
    float3 toPos_yz = pos - i_yz;
    float3 toPos_xyz = pos - i_xyz;
    
    dot_o = dot(rand_o, toPos_o) * 0.5 + 0.5;
    dot_x = dot(rand_x, toPos_x) * 0.5 + 0.5;
    dot_y = dot(rand_y, toPos_y) * 0.5 + 0.5;
    dot_z = dot(rand_z, toPos_z) * 0.5 + 0.5;
    dot_xy = dot(rand_xy, toPos_xy) * 0.5 + 0.5;
    dot_xz = dot(rand_xz, toPos_xz) * 0.5 + 0.5;
    dot_yz = dot(rand_yz, toPos_yz) * 0.5 + 0.5;
    dot_xyz = dot(rand_xyz, toPos_xyz) * 0.5 + 0.5;
  }
  
  //底面
  float value_x0 = lerp(dot_o, dot_x, sm.x);
  float value_x1 = lerp(dot_z, dot_xz, sm.x);
  float noiseXZ0 = lerp(value_x0, value_x1, sm.z);
  
  //天井
  float value_x2 = lerp(dot_y, dot_xy, sm.x);
  float value_x3 = lerp(dot_yz, dot_xyz, sm.x);
  float noiseXZ1 = lerp(value_x2, value_x3, sm.z);
  
  return lerp(noiseXZ0, noiseXZ1, sm.y);//yでブレンド
}

float2 pNoise2D(float2 pos)
{
  float2 pos_0 = pos;
  float2 pos_1 = float2(pos.y, pos.x);//対称性が生まれそうだから工夫が必要かも
  float n_0 = pNoise(pos_0);
  float n_1 = pNoise(pos_1);
  return float2(n_0, n_1);
}

float3 pNoise3D(float3 pos)
{
  float3 pos_0 = pos;
  float3 pos_1 = float3(pos.y, pos.z, pos.x);
  float3 pos_2 = float3(pos.z, pos.x, pos.y);
  float n_0 = pNoise(pos_0);
  float n_1 = pNoise(pos_1);
  float n_2 = pNoise(pos_2);
  return float3(n_0, n_1, n_2);
}

//Cellular Noise

float cNoise(float2 pos)
{
  float2 i_o = floor(pos);
  
  float nearDist = 100000000;
  
  for (int i = -1; i <= 1; i ++)
  {
    for (int j = -1; j <= 1; j ++)
    {
      float2 base_pos = i_o + float2(i, j);
      float2 rand_pos = base_pos + rand2D(base_pos) * 0.5 + 0.5;
      float dist = length(rand_pos - pos);
      if (dist < nearDist) nearDist = dist;
    }
  }
  
  return nearDist / 1.41421356;
}

float3 getNearCellPos(float3 pos)
{
  float3 i_o = floor(pos);
  
  float nearDist = 100000000;
  float3 nearPos = 0;
  
  for (int i = -1; i <= 1; i ++)
  {
    
    for (int j = -1; j <= 1; j ++)
    {
      
      for (int k = -1; k <= 1; k ++)
      {
        float3 base_pos = i_o + float3(i, j, k);
        float3 rand_pos = base_pos + rand3D(base_pos) * 0.5 + 0.5;
        float dist = length(rand_pos - pos);
        if(dist < nearDist)
        {
          nearDist = dist;
          nearPos = rand_pos;
        }
      }
    }
  }
  
  return nearPos;
}

float cNoise(float3 pos)
{
  float3 i_o = floor(pos);
  
  float nearDist = 100000000;
  
  for (int i = -1; i <= 1; i ++)
  {
    for (int j = -1; j <= 1; j ++)
    {
      for (int k = -1; k <= 1; k ++)
      {
        float3 base_pos = i_o + float3(i, j, k);
        float3 rand_pos = base_pos + rand3D(base_pos) * 0.5 + 0.5;
        float dist = length(rand_pos - pos);
        if(dist < nearDist) nearDist = dist;
      }
    }
  }
  return nearDist / 1.7320508;
}

///Curl Noise

float2 curlNoise(float2 pos)
{
  const float epsilon = 0.00001;
  
  float2 n_px = pNoise2D(pos + float2(epsilon, 0));
  float2 n_mx = pNoise2D(pos - float2(epsilon, 0));
  float2 n_py = pNoise2D(pos + float2(0, epsilon));
  float2 n_my = pNoise2D(pos - float2(0, epsilon));
  
  float x = n_my.y - n_py.y;
  float y = n_px.x - n_mx.x;
  
  return normalize(float2(x, y));
}

float3 curlNoise(float3 pos)
{
  const float epsilon = 0.00001;
  
  float3 n_px = pNoise3D(pos + float3(epsilon, 0, 0));
  float3 n_mx = pNoise3D(pos - float3(epsilon, 0, 0));
  float3 n_py = pNoise3D(pos + float3(0, epsilon, 0));
  float3 n_my = pNoise3D(pos - float3(0, epsilon, 0));
  float3 n_pz = pNoise3D(pos + float3(0, 0, epsilon));
  float3 n_mz = pNoise3D(pos - float3(0, 0, epsilon));
  
  float x = n_my.z - n_py.z - n_mz.y + n_pz.y;
  float y = n_px.z - n_mx.z - n_pz.x + n_mz.x;
  float z = n_mx.y - n_px.y - n_my.x + n_py.x;
  
  return normalize(float3(x, y, z) / 4.0);
}

///fBM

float fbm(float2 uv)
{
  float gain = 0.5;
  float freqIncrease = 2.0;
  float octaves = 5;
  
  //default value
  float amp = 0.5;
  float fre = 1.0;
  
  float ret = 0.0;//return
  
  for (int i = 0; i < octaves; i ++)
  {
    //任意のノイズを使う
    ret += valNoise(uv * fre) * amp;
    fre *= freqIncrease;
    amp *= gain;
  }
  return ret;
}

float fbm(float3 pos)
{
  float gain = 0.5;
  float freqIncrease = 2.0;
  float octaves = 5;
  
  //default value
  float amp = 0.5;
  float fre = 1.0;
  
  float maxValue = 0;
  float ret = 0.0;//return
  
  for (int i = 0; i < octaves; i ++)
  {
    //任意のノイズを使う
    ret += pNoise(pos * fre) * amp;
    fre *= freqIncrease;
    maxValue += amp;
    amp *= gain;
  }
  return ret / maxValue;
}


///Domain Warping

float3 domainWarping(float2 uv)
{
  float3 col = 0.0;
  float2 t = _Time * 0.1;
  float2 a = 0.0;
  a.x = fbm(uv + _Time.y);
  a.y = fbm(uv + float2(0, 1.0));
  
  float2 b = 0.0;
  b.x = fbm(uv + a * 2.0 + 0.15 * t.y);
  b.y = fbm(uv + a * 1.5 + 0.126 * t.y);
  
  float c = fbm(uv + a);
  
  col = lerp(float3(0.592, 0.995, 0.0),
  float3(1.0, 0.355, 0.297),
  saturate(c * c * 4.0));
  
  col = lerp(col,
  float3(0.818, 0.369, 0.925),
  saturate(length(a))
  );
  
  col = lerp(col,
  float3(1.0, 0.436, 0.103),
  saturate(length(b.x))
  );
  
  return col.rgb * (c * c * c + 2.0 * c * c);
}

float3 domainWarping(float3 pos)
{
  float3 col = 0.0;
  float4 t = _Time * 0.1;
  float3 a = 0.0;
  a.x = fbm(pos + t.y);
  a.y = fbm(pos + float3(0, 1.0, -1.0));
  a.z = fbm(pos - t.x);
  
  float3 b = 0.0;
  b.x = fbm(a * 2.0 + 0.267 * t.x);
  b.y = fbm(a * 1.5 + 0.163 * t.y);
  b.z = fbm(a * 4.3 + 0.136 * t.y);
  
  float c = fbm(pos + a + b);
  
  col = lerp(float3(0.2343, 0.96442, 0.5342),
  float3(1.0, 0.55211, 1.0),
  saturate(c * c * 4.0)
  );
  
  col = lerp(col,
  float3(0.3153, 1., 0.6753),
  saturate(length(a))
  );
  
  col = lerp(col,
  float3(1.0, 0.2653, 0.6342),
  saturate(length(b.x))
  );
  
  return col * (c * c * c + 2.0 * c * c);
}