Shader "Chroma/Chroma Transparent v2.2" {
	Properties {
        _ChromaKey ("Chroma Key", Color) = (0,1,0,1)
        _HueThreshold ("Hue Threshold", Range (0, 1)) = 0.2

        _MinShadeDarkness ("Min Shade Darkness", Range (0, 1)) = 0
        _MaxShadeDarkness ("Max Shade Darkness", Range (0, 1)) = 1

		_MainTex ("Base (RGB)", 2D) = "white" {}

        _MinSaturation ("Min Saturation", Range (0, 1)) = 0
        _MaxSaturation ("Max Saturation", Range (0, 1)) = 1
        _MinLightness ("Min Lightness", Range (0, 1)) = 0
        _MaxLightness ("Max Lightness", Range (0, 1)) = 1
	}
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite On

			Alphatest Greater 0 ZWrite Off ColorMask RGB
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 3
//   opengl - ALU: 6 to 57
//   d3d9 - ALU: 6 to 57
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 27 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[9].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R3.w, R3.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
MAD R0.y, R0.x, R0.x, -R0;
MUL R1.xyz, R0.y, c[16];
ADD R2.xyz, R2, R3;
ADD result.texcoord[2].xyz, R2, R1;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 27 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [_MainTex_ST]
"vs_3_0
; 27 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c8.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c17.x
dp4 r2.z, r0, c11
dp4 r2.y, r0, c10
dp4 r2.x, r0, c9
mul r0.y, r3.w, r3.w
dp4 r3.z, r1, c14
dp4 r3.y, r1, c13
dp4 r3.x, r1, c12
mad r0.y, r0.x, r0.x, -r0
mul r1.xyz, r0.y, c15
add r2.xyz, r2, r3
add o3.xyz, r2, r1
mov o2.z, r2.w
mov o2.y, r3.w
mov o2.x, r0
mad o1.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD2));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD2));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 6 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_3_0
; 6 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.xy, v2, c9, c9.zwzw
mad o2.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_1 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz));
  c.w = tmpvar_2;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  c.xyz = (tmpvar_1 * ((8.0 * tmpvar_19.w) * tmpvar_19.xyz));
  c.w = tmpvar_2;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 57 ALU
PARAM c[26] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[9].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[10];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[12];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[13];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[20];
DP4 R2.y, R4, c[19];
DP4 R2.x, R4, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[23];
DP4 R4.z, R0, c[22];
DP4 R4.y, R0, c[21];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R4.yzww;
ADD R0.xyz, R2, R0;
ADD result.texcoord[2].xyz, R0, R1;
MOV result.texcoord[1].z, R3.x;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R4;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 57 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
"vs_3_0
; 57 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c25, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c8.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c10
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c9
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c25.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c11
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c12
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c25.x
dp4 r2.z, r4, c19
dp4 r2.y, r4, c18
dp4 r2.x, r4, c17
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c25.y
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mad r1.xyz, r0.w, c16, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c22
dp4 r4.z, r0, c21
dp4 r4.y, r0, c20
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c23
add r2.xyz, r2, r4.yzww
add r0.xyz, r2, r0
add o3.xyz, r0, r1
mov o2.z, r3.x
mov o2.y, r3.w
mov o2.x, r4
mad o1.xy, v2, c24, c24.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD2));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.xyz = (c.xyz + (tmpvar_1 * xlv_TEXCOORD2));
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 77 to 80, TEX: 1 to 2
//   d3d9 - ALU: 81 to 83, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 77 ALU, 1 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.16666667, 1, 0, 9.9999997e-005 },
		{ 2, 4, 6 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0.y, R0.z;
MAX R2.w, R0.x, R0;
MIN R1.x, R0.y, R0.z;
MIN R1.x, R0, R1;
ADD R3.w, R2, -R1.x;
MOV R0.w, c[8].z;
ADD R1, R2.w, -R0;
RCP R2.x, R3.w;
MUL R1, R1, R2.x;
MAX R0.w, c[0].y, c[0].z;
MIN R2.x, c[0].y, c[0].z;
MAX R4.x, R0.w, c[0];
MIN R2.x, R2, c[0];
ADD R0.w, R4.x, -R2.x;
ADD R2.xyz, R1, -R1.zxyw;
RCP R3.x, R0.w;
ADD R1.xyz, R4.x, -c[0];
MUL R1.xyz, R1, R3.x;
ADD R3.xyz, R1, -R1.zxyw;
ADD R2.xyz, R2, c[9];
SGE R1.xyz, R0, R2.w;
MUL R1.xyz, R1, R2.zxyw;
MAX R1.x, R1.z, R1;
MAX R1.x, R1.y, R1;
ADD R3.xyz, R3, c[9];
SGE R2.xyz, c[0], R4.x;
MUL R2.xyz, R2, R3.zxyw;
MAX R1.z, R2, R2.x;
MAX R1.y, R2, R1.z;
ABS R1.z, R0.w;
CMP R2.x, -R1.z, R1.y, c[8].z;
ABS R1.y, R3.w;
CMP R0.w, -R1.y, R1.x, c[8].z;
MUL R2.y, R2.x, c[8].x;
MUL R1.x, R0.w, c[8];
FRC R2.y, R2;
CMP R1.z, -R1, R2.y, R2.x;
FRC R1.x, R1;
CMP R0.w, -R1.y, R1.x, R0;
ADD R0.w, R0, -R1.z;
ABS R1.z, R0.w;
RCP R1.x, R1.w;
MOV R0.w, c[8];
CMP R1.x, -R1.y, R1, c[8].z;
ADD R1.w, R0, c[5].x;
ADD R1.y, -R0.w, c[4].x;
SLT R1.w, R1.x, R1;
SLT R1.x, R1.y, R1;
MUL R1.y, R1.x, R1.w;
SLT R1.x, R1.z, c[1];
MUL R1.x, R1, R1.y;
ADD R1.y, R0.w, c[7].x;
ADD R2.xyz, -R0, c[0];
DP3 R1.z, R2, c[10];
ADD R0.w, -R0, c[6].x;
SLT R1.y, R2.w, R1;
SLT R0.w, R0, R2;
MUL R0.w, R0, R1.y;
MUL R0.w, R1.x, R0;
MOV R1.y, c[2].x;
ADD R1.x, -R1.y, c[3];
ABS R1.y, R1.x;
CMP R1.y, -R1, c[8].z, c[8];
ABS R1.y, R1;
RCP R2.x, R1.x;
CMP R1.x, -R1.y, c[8].z, c[8].y;
MUL R1.x, R0.w, R1;
ADD R1.w, R1.z, -c[2].x;
MUL R1.y, R1.w, R2.x;
CMP R1.x, -R1, R1.y, c[8].y;
ABS R0.w, R0;
CMP R0.w, -R0, c[8].z, c[8].y;
ADD R1.y, -R1.z, c[8];
CMP R0.xyz, -R0.w, R0, R1.y;
CMP result.color.w, -R0, c[8].y, R1.x;
MAD result.color.xyz, R0, fragment.texcoord[2], R0;
END
# 77 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 81 ALU, 1 TEX
dcl_2d s0
def c8, 1.00000000, 0.00000000, 0.16666667, -0.00010000
def c9, 2.00000000, 4.00000000, 6.00000000, 0
def c10, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord2 v1.xyz
texld r0.xyz, v0, s0
max r0.w, r0.y, r0.z
max r2.w, r0.x, r0
min r1.x, r0.y, r0.z
min r1.x, r0, r1
add r3.w, r2, -r1.x
mov r0.w, c8.y
add r1, r2.w, -r0
rcp r2.x, r3.w
mul r1, r1, r2.x
max r0.w, c0.y, c0.z
max r4.x, r0.w, c0
add r1.xyz, r1, -r1.zxyw
min r2.x, c0.y, c0.z
min r2.x, r2, c0
add r0.w, r4.x, -r2.x
add r2.xyz, -r2.w, r0
rcp r4.y, r0.w
add r3.xyz, r4.x, -c0
mul r3.xyz, r3, r4.y
add r3.xyz, r3, -r3.zxyw
cmp r2.xyz, r2, c8.x, c8.y
add r1.xyz, r1, c9
mul r1.xyz, r2, r1.zxyw
max r1.x, r1.z, r1
add r2.xyz, -r4.x, c0
max r1.x, r1.y, r1
add r3.xyz, r3, c9
cmp r2.xyz, r2, c8.x, c8.y
mul r2.xyz, r2, r3.zxyw
max r1.z, r2, r2.x
max r1.y, r2, r1.z
abs r1.z, r0.w
cmp r2.x, -r1.z, c8.y, r1.y
abs r0.w, r3
cmp r1.x, -r0.w, c8.y, r1
mul r2.y, r2.x, c8.z
mul r1.y, r1.x, c8.z
frc r1.y, r1
frc r2.y, r2
cmp r1.x, -r0.w, r1, r1.y
cmp r1.z, -r1, r2.x, r2.y
add r1.y, r1.x, -r1.z
rcp r1.x, r1.w
cmp r0.w, -r0, c8.y, r1.x
abs r1.y, r1
add r1.x, r1.y, -c1
add r1.y, r0.w, -c5.x
add r0.w, -r0, c4.x
add r1.y, r1, c8.w
add r0.w, r0, c8
cmp r0.w, r0, c8.y, c8.x
cmp r1.y, r1, c8, c8.x
mul_pp r1.y, r0.w, r1
cmp r0.w, r1.x, c8.y, c8.x
mul_pp r0.w, r0, r1.y
add r1.y, r2.w, -c7.x
add r1.x, -r2.w, c6
add r1.y, r1, c8.w
add r1.x, r1, c8.w
cmp r1.y, r1, c8, c8.x
cmp r1.x, r1, c8.y, c8
mul_pp r1.x, r1, r1.y
mov r1.y, c3.x
add r1.w, -c2.x, r1.y
mul_pp r0.w, r0, r1.x
add r1.xyz, -r0, c0
dp3_pp r1.x, r1, c10
abs r2.x, r1.w
add r1.z, r1.x, -c2.x
cmp r1.y, -r2.x, c8.x, c8
abs_pp r1.y, r1
rcp r1.w, r1.w
cmp_pp r1.y, -r1, c8.x, c8
mul_pp r1.y, r0.w, r1
mul r1.z, r1, r1.w
abs_pp r0.w, r0
cmp_pp r1.y, -r1, c8.x, r1.z
add r1.x, -r1, c8
cmp_pp r0.xyz, -r0.w, r0, r1.x
cmp_pp oC0.w, -r0, c8.x, r1.y
mad_pp oC0.xyz, r0, v1, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 80 ALU, 2 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.16666667, 1, 0, 9.9999997e-005 },
		{ 2, 4, 6, 8 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0.y, R0.z;
MAX R2.w, R0.x, R0;
MIN R1.x, R0.y, R0.z;
MIN R1.x, R0, R1;
ADD R3.w, R2, -R1.x;
MOV R0.w, c[8].z;
ADD R1, R2.w, -R0;
RCP R2.x, R3.w;
MUL R1, R1, R2.x;
MAX R0.w, c[0].y, c[0].z;
MIN R2.x, c[0].y, c[0].z;
MAX R4.x, R0.w, c[0];
MIN R2.x, R2, c[0];
ADD R0.w, R4.x, -R2.x;
ADD R2.xyz, R1, -R1.zxyw;
RCP R3.x, R0.w;
ADD R1.xyz, R4.x, -c[0];
MUL R1.xyz, R1, R3.x;
ADD R3.xyz, R1, -R1.zxyw;
ADD R2.xyz, R2, c[9];
SGE R1.xyz, R0, R2.w;
MUL R1.xyz, R1, R2.zxyw;
MAX R1.x, R1.z, R1;
MAX R1.x, R1.y, R1;
ADD R3.xyz, R3, c[9];
SGE R2.xyz, c[0], R4.x;
MUL R2.xyz, R2, R3.zxyw;
MAX R1.z, R2, R2.x;
MAX R1.y, R2, R1.z;
ABS R1.z, R0.w;
CMP R2.x, -R1.z, R1.y, c[8].z;
ABS R0.w, R3;
CMP R1.x, -R0.w, R1, c[8].z;
MUL R2.y, R2.x, c[8].x;
MUL R1.y, R1.x, c[8].x;
FRC R2.y, R2;
FRC R1.y, R1;
CMP R1.x, -R0.w, R1.y, R1;
CMP R1.z, -R1, R2.y, R2.x;
ADD R1.x, R1, -R1.z;
RCP R1.y, R1.w;
ABS R1.x, R1;
SLT R1.z, R1.x, c[1].x;
MOV R1.x, c[8].w;
CMP R0.w, -R0, R1.y, c[8].z;
ADD R1.w, R1.x, c[5].x;
ADD R1.y, -R1.x, c[4].x;
SLT R1.w, R0, R1;
SLT R0.w, R1.y, R0;
ADD R1.y, R1.x, c[7].x;
MUL R0.w, R0, R1;
ADD R1.x, -R1, c[6];
SLT R1.y, R2.w, R1;
SLT R1.x, R1, R2.w;
MUL R1.x, R1, R1.y;
MUL R0.w, R1.z, R0;
MUL R0.w, R0, R1.x;
MOV R1.x, c[2];
ADD R1.w, -R1.x, c[3].x;
ADD R1.xyz, -R0, c[0];
DP3 R1.y, R1, c[10];
ABS R2.x, R1.w;
CMP R1.x, -R2, c[8].z, c[8].y;
ABS R2.y, R0.w;
CMP R2.x, -R2.y, c[8].z, c[8].y;
ADD R2.y, -R1, c[8];
ABS R1.x, R1;
CMP R1.x, -R1, c[8].z, c[8].y;
MUL R0.w, R0, R1.x;
ADD R1.z, R1.y, -c[2].x;
RCP R1.w, R1.w;
MUL R1.z, R1, R1.w;
CMP R0.w, -R0, R1.z, c[8].y;
TEX R1, fragment.texcoord[1], texture[1], 2D;
CMP R0.xyz, -R2.x, R0, R2.y;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R1, R0;
CMP result.color.w, -R2.x, c[8].y, R0;
MUL result.color.xyz, R0, c[9].w;
END
# 80 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_3_0
; 83 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c8, 1.00000000, 0.00000000, 0.16666667, -0.00010000
def c9, 2.00000000, 4.00000000, 6.00000000, 8.00000000
def c10, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
texld r0.xyz, v0, s0
max r0.w, r0.y, r0.z
max r2.w, r0.x, r0
min r1.x, r0.y, r0.z
min r1.x, r0, r1
add r3.w, r2, -r1.x
mov r0.w, c8.y
add r1, r2.w, -r0
rcp r2.x, r3.w
mul r1, r1, r2.x
max r0.w, c0.y, c0.z
max r4.x, r0.w, c0
add r1.xyz, r1, -r1.zxyw
min r2.x, c0.y, c0.z
min r2.x, r2, c0
add r0.w, r4.x, -r2.x
add r2.xyz, -r2.w, r0
rcp r4.y, r0.w
add r3.xyz, r4.x, -c0
mul r3.xyz, r3, r4.y
add r3.xyz, r3, -r3.zxyw
cmp r2.xyz, r2, c8.x, c8.y
add r1.xyz, r1, c9
mul r1.xyz, r2, r1.zxyw
max r1.x, r1.z, r1
add r2.xyz, -r4.x, c0
max r1.x, r1.y, r1
add r3.xyz, r3, c9
cmp r2.xyz, r2, c8.x, c8.y
mul r2.xyz, r2, r3.zxyw
max r1.z, r2, r2.x
max r1.y, r2, r1.z
abs r1.z, r0.w
cmp r2.x, -r1.z, c8.y, r1.y
abs r0.w, r3
cmp r1.x, -r0.w, c8.y, r1
mul r2.y, r2.x, c8.z
mul r1.y, r1.x, c8.z
frc r2.y, r2
cmp r1.z, -r1, r2.x, r2.y
frc r1.y, r1
cmp r1.x, -r0.w, r1, r1.y
add r1.y, r1.x, -r1.z
rcp r1.x, r1.w
cmp r0.w, -r0, c8.y, r1.x
abs r1.y, r1
add r1.x, r1.y, -c1
add r1.y, r0.w, -c5.x
add r0.w, -r0, c4.x
add r1.y, r1, c8.w
add r0.w, r0, c8
add r2.xyz, -r0, c0
cmp r0.w, r0, c8.y, c8.x
cmp r1.y, r1, c8, c8.x
mul_pp r1.y, r0.w, r1
cmp r0.w, r1.x, c8.y, c8.x
mul_pp r0.w, r0, r1.y
add r1.y, r2.w, -c7.x
add r1.x, -r2.w, c6
add r1.y, r1, c8.w
add r1.x, r1, c8.w
cmp r1.y, r1, c8, c8.x
cmp r1.x, r1, c8.y, c8
mul_pp r1.x, r1, r1.y
mul_pp r1.x, r0.w, r1
mov r1.y, c3.x
add r0.w, -c2.x, r1.y
dp3_pp r1.y, r2, c10
abs r1.z, r0.w
cmp r1.z, -r1, c8.x, c8.y
rcp r2.x, r0.w
abs_pp r1.z, r1
cmp_pp r0.w, -r1.z, c8.x, c8.y
add r1.w, r1.y, -c2.x
mul r1.z, r1.w, r2.x
mul_pp r0.w, r1.x, r0
abs_pp r2.x, r1
cmp_pp r0.w, -r0, c8.x, r1.z
add r2.y, -r1, c8.x
texld r1, v1, s1
cmp_pp r0.xyz, -r2.x, r0, r2.y
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r1, r0
cmp_pp oC0.w, -r2.x, c8.x, r0
mul_pp oC0.xyz, r0, c9.w
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		Blend SrcAlpha One
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 10 to 18
//   d3d9 - ALU: 10 to 18
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o4.z, r0, c10
dp4 o4.y, r0, c9
dp4 o4.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
mad o1.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 11 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 10 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
MOV result.texcoord[2].xyz, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 10 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 10 [_MainTex_ST]
"vs_3_0
; 10 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c8.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
mov o3.xyz, c9
mad o1.xy, v2, c10, c10.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].w, R0, c[12];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o4.w, r0, c11
dp4 o4.z, r0, c10
dp4 o4.y, r0, c9
dp4 o4.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
mad o1.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o4.z, r0, c10
dp4 o4.y, r0, c9
dp4 o4.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
mad o1.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 16 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_3_0
; 16 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 o4.y, r0, c9
dp4 o4.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c13
mad o1.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp float _MinShadeDarkness;
uniform highp float _MinSaturation;
uniform highp float _MinLightness;
uniform highp float _MaxShadeDarkness;
uniform highp float _MaxSaturation;
uniform highp float _MaxLightness;
uniform sampler2D _MainTex;
uniform highp float _HueThreshold;
uniform highp vec4 _ChromaKey;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_1 = vec3(0.0, 0.0, 0.0);
  tmpvar_2 = 0.0;
  highp float darkness;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  c_i0 = tmpvar_3;
  highp vec3 RGB;
  RGB = c_i0.xyz;
  highp vec4 Delta;
  highp vec3 HSV;
  HSV = vec3(0.0, 0.0, 0.0);
  HSV.z = max (RGB.x, max (RGB.y, RGB.z));
  highp float tmpvar_4;
  tmpvar_4 = (HSV.z - min (RGB.x, min (RGB.y, RGB.z)));
  if ((tmpvar_4 != 0.0)) {
    highp vec4 tmpvar_5;
    tmpvar_5.w = 0.0;
    tmpvar_5.xyz = RGB;
    highp vec4 tmpvar_6;
    tmpvar_6 = ((HSV.z - tmpvar_5) / tmpvar_4);
    Delta = tmpvar_6;
    Delta.xyz = (tmpvar_6.xyz - tmpvar_6.zxy);
    Delta.xyz = (Delta.xyz + vec3(2.0, 4.0, 6.0));
    Delta.xyz = (step (HSV.z, RGB.x) * Delta.zxy).yzx;
    HSV.x = max (Delta.x, max (Delta.y, Delta.z));
    HSV.x = fract ((HSV.x / 6.0));
    HSV.y = (1.0/(tmpvar_6.w));
  };
  highp vec4 Delta_i0;
  highp vec3 HSV_i0;
  HSV_i0 = vec3(0.0, 0.0, 0.0);
  HSV_i0.z = max (_ChromaKey.x, max (_ChromaKey.y, _ChromaKey.z));
  highp float tmpvar_7;
  tmpvar_7 = (HSV_i0.z - min (_ChromaKey.x, min (_ChromaKey.y, _ChromaKey.z)));
  if ((tmpvar_7 != 0.0)) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 0.0;
    tmpvar_8.xyz = _ChromaKey.xyz;
    highp vec4 tmpvar_9;
    tmpvar_9 = ((HSV_i0.z - tmpvar_8) / tmpvar_7);
    Delta_i0 = tmpvar_9;
    Delta_i0.xyz = (tmpvar_9.xyz - tmpvar_9.zxy);
    Delta_i0.xyz = (Delta_i0.xyz + vec3(2.0, 4.0, 6.0));
    Delta_i0.xyz = (step (HSV_i0.z, _ChromaKey.x) * Delta_i0.zxy).yzx;
    HSV_i0.x = max (Delta_i0.x, max (Delta_i0.y, Delta_i0.z));
    HSV_i0.x = fract ((HSV_i0.x / 6.0));
    HSV_i0.y = (1.0/(tmpvar_9.w));
  };
  bool tmpvar_10;
  tmpvar_10 = (abs ((HSV.x - HSV_i0.x)) < _HueThreshold);
  bool tmpvar_11;
  if ((HSV.y > (_MinSaturation - 0.0001))) {
    tmpvar_11 = (HSV.y < (_MaxSaturation + 0.0001));
  } else {
    tmpvar_11 = bool(0);
  };
  bool tmpvar_12;
  if ((HSV.z > (_MinLightness - 0.0001))) {
    tmpvar_12 = (HSV.z < (_MaxLightness + 0.0001));
  } else {
    tmpvar_12 = bool(0);
  };
  bool tmpvar_13;
  if (tmpvar_10) {
    tmpvar_13 = tmpvar_11;
  } else {
    tmpvar_13 = bool(0);
  };
  bool tmpvar_14;
  if (tmpvar_13) {
    tmpvar_14 = tmpvar_12;
  } else {
    tmpvar_14 = bool(0);
  };
  if (tmpvar_14) {
    lowp vec3 c_i0;
    c_i0 = (_ChromaKey.xyz - c_i0.xyz);
    lowp float tmpvar_15;
    tmpvar_15 = dot (c_i0, vec3(0.22, 0.707, 0.071));
    darkness = tmpvar_15;
    highp vec3 tmpvar_16;
    tmpvar_16 = vec3((1.0 - darkness));
    tmpvar_1 = tmpvar_16;
    if (((_MaxShadeDarkness - _MinShadeDarkness) == 0.0)) {
      tmpvar_2 = 1.0;
    } else {
      highp float tmpvar_17;
      tmpvar_17 = ((darkness - _MinShadeDarkness) / (_MaxShadeDarkness - _MinShadeDarkness));
      tmpvar_2 = tmpvar_17;
    };
  } else {
    mediump vec3 tmpvar_18;
    tmpvar_18 = c_i0.xyz;
    tmpvar_1 = tmpvar_18;
    tmpvar_2 = 1.0;
  };
  mediump vec4 c_i0_i1;
  c_i0_i1.xyz = tmpvar_1;
  c_i0_i1.w = tmpvar_2;
  c = c_i0_i1;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 76 to 76, TEX: 1 to 1
//   d3d9 - ALU: 80 to 80, TEX: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 76 ALU, 1 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.16666667, 1, 0, 9.9999997e-005 },
		{ 2, 4, 6 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0.y, R0.z;
MAX R2.w, R0.x, R0;
MIN R1.x, R0.y, R0.z;
MIN R1.x, R0, R1;
ADD R3.w, R2, -R1.x;
MOV R0.w, c[8].z;
ADD R1, R2.w, -R0;
RCP R2.x, R3.w;
MUL R1, R1, R2.x;
MAX R0.w, c[0].y, c[0].z;
MIN R2.x, c[0].y, c[0].z;
MAX R4.x, R0.w, c[0];
MIN R2.x, R2, c[0];
ADD R0.w, R4.x, -R2.x;
ADD R2.xyz, R1, -R1.zxyw;
RCP R3.x, R0.w;
ADD R1.xyz, R4.x, -c[0];
MUL R1.xyz, R1, R3.x;
ADD R3.xyz, R1, -R1.zxyw;
ADD R2.xyz, R2, c[9];
SGE R1.xyz, R0, R2.w;
MUL R1.xyz, R1, R2.zxyw;
MAX R1.x, R1.z, R1;
MAX R1.x, R1.y, R1;
ADD R3.xyz, R3, c[9];
SGE R2.xyz, c[0], R4.x;
MUL R2.xyz, R2, R3.zxyw;
MAX R1.z, R2, R2.x;
MAX R1.y, R2, R1.z;
ABS R1.z, R0.w;
CMP R2.x, -R1.z, R1.y, c[8].z;
ABS R0.w, R3;
CMP R1.x, -R0.w, R1, c[8].z;
MUL R2.y, R2.x, c[8].x;
MUL R1.y, R1.x, c[8].x;
FRC R2.y, R2;
FRC R1.y, R1;
CMP R1.x, -R0.w, R1.y, R1;
CMP R1.z, -R1, R2.y, R2.x;
ADD R1.x, R1, -R1.z;
RCP R1.y, R1.w;
ABS R1.x, R1;
SLT R1.z, R1.x, c[1].x;
MOV R1.x, c[8].w;
CMP R0.w, -R0, R1.y, c[8].z;
ADD R1.w, R1.x, c[5].x;
ADD R1.y, -R1.x, c[4].x;
SLT R1.w, R0, R1;
SLT R0.w, R1.y, R0;
ADD R1.y, R1.x, c[7].x;
MUL R0.w, R0, R1;
ADD R1.x, -R1, c[6];
MUL R0.w, R1.z, R0;
SLT R1.y, R2.w, R1;
SLT R1.x, R1, R2.w;
MUL R1.x, R1, R1.y;
MUL R1.w, R0, R1.x;
MOV R1.x, c[2];
ADD R2.x, -R1, c[3];
ADD R1.xyz, -R0, c[0];
DP3 R1.y, R1, c[10];
ABS R2.y, R2.x;
ADD R1.z, R1.y, -c[2].x;
ABS R0.w, R1;
CMP R1.x, -R2.y, c[8].z, c[8].y;
ABS R1.x, R1;
RCP R2.x, R2.x;
CMP R1.x, -R1, c[8].z, c[8].y;
CMP R0.w, -R0, c[8].z, c[8].y;
ADD R1.y, -R1, c[8];
MUL R1.z, R1, R2.x;
MUL R1.x, R1.w, R1;
CMP R1.x, -R1, R1.z, c[8].y;
CMP result.color.w, -R0, c[8].y, R1.x;
CMP result.color.xyz, -R0.w, R0, R1.y;
END
# 76 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 80 ALU, 1 TEX
dcl_2d s0
def c8, 1.00000000, 0.00000000, 0.16666667, -0.00010000
def c9, 2.00000000, 4.00000000, 6.00000000, 0
def c10, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
texld r0.xyz, v0, s0
max r0.w, r0.y, r0.z
max r2.w, r0.x, r0
min r1.x, r0.y, r0.z
min r1.x, r0, r1
add r3.w, r2, -r1.x
mov r0.w, c8.y
add r1, r2.w, -r0
rcp r2.x, r3.w
mul r1, r1, r2.x
max r0.w, c0.y, c0.z
max r4.x, r0.w, c0
add r1.xyz, r1, -r1.zxyw
min r2.x, c0.y, c0.z
min r2.x, r2, c0
add r0.w, r4.x, -r2.x
add r2.xyz, -r2.w, r0
rcp r4.y, r0.w
add r3.xyz, r4.x, -c0
mul r3.xyz, r3, r4.y
add r3.xyz, r3, -r3.zxyw
cmp r2.xyz, r2, c8.x, c8.y
add r1.xyz, r1, c9
mul r1.xyz, r2, r1.zxyw
max r1.x, r1.z, r1
add r2.xyz, -r4.x, c0
max r1.x, r1.y, r1
add r3.xyz, r3, c9
cmp r2.xyz, r2, c8.x, c8.y
mul r2.xyz, r2, r3.zxyw
max r1.z, r2, r2.x
max r1.y, r2, r1.z
abs r1.z, r0.w
cmp r2.x, -r1.z, c8.y, r1.y
abs r0.w, r3
cmp r1.x, -r0.w, c8.y, r1
mul r2.y, r2.x, c8.z
mul r1.y, r1.x, c8.z
frc r2.y, r2
frc r1.y, r1
cmp r1.z, -r1, r2.x, r2.y
cmp r1.x, -r0.w, r1, r1.y
add r1.x, r1, -r1.z
abs r1.y, r1.x
rcp r1.x, r1.w
add r1.z, r2.w, -c7.x
add r1.z, r1, c8.w
cmp r0.w, -r0, c8.y, r1.x
add r1.y, r1, -c1.x
cmp r1.x, r1.y, c8.y, c8
add r1.y, r0.w, -c5.x
add r0.w, -r0, c4.x
add r1.y, r1, c8.w
add r0.w, r0, c8
cmp r1.y, r1, c8, c8.x
cmp r0.w, r0, c8.y, c8.x
mul_pp r0.w, r0, r1.y
mul_pp r0.w, r1.x, r0
mov r1.x, c3
add r2.x, -c2, r1
abs r2.y, r2.x
add r1.y, -r2.w, c6.x
add r1.y, r1, c8.w
cmp r1.z, r1, c8.y, c8.x
cmp r1.y, r1, c8, c8.x
mul_pp r1.y, r1, r1.z
mul_pp r1.w, r0, r1.y
add r1.xyz, -r0, c0
dp3_pp r1.x, r1, c10
add r1.z, r1.x, -c2.x
cmp r1.y, -r2, c8.x, c8
abs_pp r1.y, r1
rcp r2.x, r2.x
cmp_pp r1.y, -r1, c8.x, c8
abs_pp r0.w, r1
add r1.x, -r1, c8
mul r1.z, r1, r2.x
mul_pp r1.y, r1.w, r1
cmp_pp r1.y, -r1, c8.x, r1.z
cmp_pp oC0.w, -r0, c8.x, r1.y
cmp_pp oC0.xyz, -r0.w, r0, r1.x
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 76 ALU, 1 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.16666667, 1, 0, 9.9999997e-005 },
		{ 2, 4, 6 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0.y, R0.z;
MAX R2.w, R0.x, R0;
MIN R1.x, R0.y, R0.z;
MIN R1.x, R0, R1;
ADD R3.w, R2, -R1.x;
MOV R0.w, c[8].z;
ADD R1, R2.w, -R0;
RCP R2.x, R3.w;
MUL R1, R1, R2.x;
MAX R0.w, c[0].y, c[0].z;
MIN R2.x, c[0].y, c[0].z;
MAX R4.x, R0.w, c[0];
MIN R2.x, R2, c[0];
ADD R0.w, R4.x, -R2.x;
ADD R2.xyz, R1, -R1.zxyw;
RCP R3.x, R0.w;
ADD R1.xyz, R4.x, -c[0];
MUL R1.xyz, R1, R3.x;
ADD R3.xyz, R1, -R1.zxyw;
ADD R2.xyz, R2, c[9];
SGE R1.xyz, R0, R2.w;
MUL R1.xyz, R1, R2.zxyw;
MAX R1.x, R1.z, R1;
MAX R1.x, R1.y, R1;
ADD R3.xyz, R3, c[9];
SGE R2.xyz, c[0], R4.x;
MUL R2.xyz, R2, R3.zxyw;
MAX R1.z, R2, R2.x;
MAX R1.y, R2, R1.z;
ABS R1.z, R0.w;
CMP R2.x, -R1.z, R1.y, c[8].z;
ABS R0.w, R3;
CMP R1.x, -R0.w, R1, c[8].z;
MUL R2.y, R2.x, c[8].x;
MUL R1.y, R1.x, c[8].x;
FRC R2.y, R2;
FRC R1.y, R1;
CMP R1.x, -R0.w, R1.y, R1;
CMP R1.z, -R1, R2.y, R2.x;
ADD R1.x, R1, -R1.z;
RCP R1.y, R1.w;
ABS R1.x, R1;
SLT R1.z, R1.x, c[1].x;
MOV R1.x, c[8].w;
CMP R0.w, -R0, R1.y, c[8].z;
ADD R1.w, R1.x, c[5].x;
ADD R1.y, -R1.x, c[4].x;
SLT R1.w, R0, R1;
SLT R0.w, R1.y, R0;
ADD R1.y, R1.x, c[7].x;
MUL R0.w, R0, R1;
ADD R1.x, -R1, c[6];
MUL R0.w, R1.z, R0;
SLT R1.y, R2.w, R1;
SLT R1.x, R1, R2.w;
MUL R1.x, R1, R1.y;
MUL R1.w, R0, R1.x;
MOV R1.x, c[2];
ADD R2.x, -R1, c[3];
ADD R1.xyz, -R0, c[0];
DP3 R1.y, R1, c[10];
ABS R2.y, R2.x;
ADD R1.z, R1.y, -c[2].x;
ABS R0.w, R1;
CMP R1.x, -R2.y, c[8].z, c[8].y;
ABS R1.x, R1;
RCP R2.x, R2.x;
CMP R1.x, -R1, c[8].z, c[8].y;
CMP R0.w, -R0, c[8].z, c[8].y;
ADD R1.y, -R1, c[8];
MUL R1.z, R1, R2.x;
MUL R1.x, R1.w, R1;
CMP R1.x, -R1, R1.z, c[8].y;
CMP result.color.w, -R0, c[8].y, R1.x;
CMP result.color.xyz, -R0.w, R0, R1.y;
END
# 76 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 80 ALU, 1 TEX
dcl_2d s0
def c8, 1.00000000, 0.00000000, 0.16666667, -0.00010000
def c9, 2.00000000, 4.00000000, 6.00000000, 0
def c10, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
texld r0.xyz, v0, s0
max r0.w, r0.y, r0.z
max r2.w, r0.x, r0
min r1.x, r0.y, r0.z
min r1.x, r0, r1
add r3.w, r2, -r1.x
mov r0.w, c8.y
add r1, r2.w, -r0
rcp r2.x, r3.w
mul r1, r1, r2.x
max r0.w, c0.y, c0.z
max r4.x, r0.w, c0
add r1.xyz, r1, -r1.zxyw
min r2.x, c0.y, c0.z
min r2.x, r2, c0
add r0.w, r4.x, -r2.x
add r2.xyz, -r2.w, r0
rcp r4.y, r0.w
add r3.xyz, r4.x, -c0
mul r3.xyz, r3, r4.y
add r3.xyz, r3, -r3.zxyw
cmp r2.xyz, r2, c8.x, c8.y
add r1.xyz, r1, c9
mul r1.xyz, r2, r1.zxyw
max r1.x, r1.z, r1
add r2.xyz, -r4.x, c0
max r1.x, r1.y, r1
add r3.xyz, r3, c9
cmp r2.xyz, r2, c8.x, c8.y
mul r2.xyz, r2, r3.zxyw
max r1.z, r2, r2.x
max r1.y, r2, r1.z
abs r1.z, r0.w
cmp r2.x, -r1.z, c8.y, r1.y
abs r0.w, r3
cmp r1.x, -r0.w, c8.y, r1
mul r2.y, r2.x, c8.z
mul r1.y, r1.x, c8.z
frc r2.y, r2
frc r1.y, r1
cmp r1.z, -r1, r2.x, r2.y
cmp r1.x, -r0.w, r1, r1.y
add r1.x, r1, -r1.z
abs r1.y, r1.x
rcp r1.x, r1.w
add r1.z, r2.w, -c7.x
add r1.z, r1, c8.w
cmp r0.w, -r0, c8.y, r1.x
add r1.y, r1, -c1.x
cmp r1.x, r1.y, c8.y, c8
add r1.y, r0.w, -c5.x
add r0.w, -r0, c4.x
add r1.y, r1, c8.w
add r0.w, r0, c8
cmp r1.y, r1, c8, c8.x
cmp r0.w, r0, c8.y, c8.x
mul_pp r0.w, r0, r1.y
mul_pp r0.w, r1.x, r0
mov r1.x, c3
add r2.x, -c2, r1
abs r2.y, r2.x
add r1.y, -r2.w, c6.x
add r1.y, r1, c8.w
cmp r1.z, r1, c8.y, c8.x
cmp r1.y, r1, c8, c8.x
mul_pp r1.y, r1, r1.z
mul_pp r1.w, r0, r1.y
add r1.xyz, -r0, c0
dp3_pp r1.x, r1, c10
add r1.z, r1.x, -c2.x
cmp r1.y, -r2, c8.x, c8
abs_pp r1.y, r1
rcp r2.x, r2.x
cmp_pp r1.y, -r1, c8.x, c8
abs_pp r0.w, r1
add r1.x, -r1, c8
mul r1.z, r1, r2.x
mul_pp r1.y, r1.w, r1
cmp_pp r1.y, -r1, c8.x, r1.z
cmp_pp oC0.w, -r0, c8.x, r1.y
cmp_pp oC0.xyz, -r0.w, r0, r1.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 76 ALU, 1 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.16666667, 1, 0, 9.9999997e-005 },
		{ 2, 4, 6 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0.y, R0.z;
MAX R2.w, R0.x, R0;
MIN R1.x, R0.y, R0.z;
MIN R1.x, R0, R1;
ADD R3.w, R2, -R1.x;
MOV R0.w, c[8].z;
ADD R1, R2.w, -R0;
RCP R2.x, R3.w;
MUL R1, R1, R2.x;
MAX R0.w, c[0].y, c[0].z;
MIN R2.x, c[0].y, c[0].z;
MAX R4.x, R0.w, c[0];
MIN R2.x, R2, c[0];
ADD R0.w, R4.x, -R2.x;
ADD R2.xyz, R1, -R1.zxyw;
RCP R3.x, R0.w;
ADD R1.xyz, R4.x, -c[0];
MUL R1.xyz, R1, R3.x;
ADD R3.xyz, R1, -R1.zxyw;
ADD R2.xyz, R2, c[9];
SGE R1.xyz, R0, R2.w;
MUL R1.xyz, R1, R2.zxyw;
MAX R1.x, R1.z, R1;
MAX R1.x, R1.y, R1;
ADD R3.xyz, R3, c[9];
SGE R2.xyz, c[0], R4.x;
MUL R2.xyz, R2, R3.zxyw;
MAX R1.z, R2, R2.x;
MAX R1.y, R2, R1.z;
ABS R1.z, R0.w;
CMP R2.x, -R1.z, R1.y, c[8].z;
ABS R0.w, R3;
CMP R1.x, -R0.w, R1, c[8].z;
MUL R2.y, R2.x, c[8].x;
MUL R1.y, R1.x, c[8].x;
FRC R2.y, R2;
FRC R1.y, R1;
CMP R1.x, -R0.w, R1.y, R1;
CMP R1.z, -R1, R2.y, R2.x;
ADD R1.x, R1, -R1.z;
RCP R1.y, R1.w;
ABS R1.x, R1;
SLT R1.z, R1.x, c[1].x;
MOV R1.x, c[8].w;
CMP R0.w, -R0, R1.y, c[8].z;
ADD R1.w, R1.x, c[5].x;
ADD R1.y, -R1.x, c[4].x;
SLT R1.w, R0, R1;
SLT R0.w, R1.y, R0;
ADD R1.y, R1.x, c[7].x;
MUL R0.w, R0, R1;
ADD R1.x, -R1, c[6];
MUL R0.w, R1.z, R0;
SLT R1.y, R2.w, R1;
SLT R1.x, R1, R2.w;
MUL R1.x, R1, R1.y;
MUL R1.w, R0, R1.x;
MOV R1.x, c[2];
ADD R2.x, -R1, c[3];
ADD R1.xyz, -R0, c[0];
DP3 R1.y, R1, c[10];
ABS R2.y, R2.x;
ADD R1.z, R1.y, -c[2].x;
ABS R0.w, R1;
CMP R1.x, -R2.y, c[8].z, c[8].y;
ABS R1.x, R1;
RCP R2.x, R2.x;
CMP R1.x, -R1, c[8].z, c[8].y;
CMP R0.w, -R0, c[8].z, c[8].y;
ADD R1.y, -R1, c[8];
MUL R1.z, R1, R2.x;
MUL R1.x, R1.w, R1;
CMP R1.x, -R1, R1.z, c[8].y;
CMP result.color.w, -R0, c[8].y, R1.x;
CMP result.color.xyz, -R0.w, R0, R1.y;
END
# 76 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 80 ALU, 1 TEX
dcl_2d s0
def c8, 1.00000000, 0.00000000, 0.16666667, -0.00010000
def c9, 2.00000000, 4.00000000, 6.00000000, 0
def c10, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
texld r0.xyz, v0, s0
max r0.w, r0.y, r0.z
max r2.w, r0.x, r0
min r1.x, r0.y, r0.z
min r1.x, r0, r1
add r3.w, r2, -r1.x
mov r0.w, c8.y
add r1, r2.w, -r0
rcp r2.x, r3.w
mul r1, r1, r2.x
max r0.w, c0.y, c0.z
max r4.x, r0.w, c0
add r1.xyz, r1, -r1.zxyw
min r2.x, c0.y, c0.z
min r2.x, r2, c0
add r0.w, r4.x, -r2.x
add r2.xyz, -r2.w, r0
rcp r4.y, r0.w
add r3.xyz, r4.x, -c0
mul r3.xyz, r3, r4.y
add r3.xyz, r3, -r3.zxyw
cmp r2.xyz, r2, c8.x, c8.y
add r1.xyz, r1, c9
mul r1.xyz, r2, r1.zxyw
max r1.x, r1.z, r1
add r2.xyz, -r4.x, c0
max r1.x, r1.y, r1
add r3.xyz, r3, c9
cmp r2.xyz, r2, c8.x, c8.y
mul r2.xyz, r2, r3.zxyw
max r1.z, r2, r2.x
max r1.y, r2, r1.z
abs r1.z, r0.w
cmp r2.x, -r1.z, c8.y, r1.y
abs r0.w, r3
cmp r1.x, -r0.w, c8.y, r1
mul r2.y, r2.x, c8.z
mul r1.y, r1.x, c8.z
frc r2.y, r2
frc r1.y, r1
cmp r1.z, -r1, r2.x, r2.y
cmp r1.x, -r0.w, r1, r1.y
add r1.x, r1, -r1.z
abs r1.y, r1.x
rcp r1.x, r1.w
add r1.z, r2.w, -c7.x
add r1.z, r1, c8.w
cmp r0.w, -r0, c8.y, r1.x
add r1.y, r1, -c1.x
cmp r1.x, r1.y, c8.y, c8
add r1.y, r0.w, -c5.x
add r0.w, -r0, c4.x
add r1.y, r1, c8.w
add r0.w, r0, c8
cmp r1.y, r1, c8, c8.x
cmp r0.w, r0, c8.y, c8.x
mul_pp r0.w, r0, r1.y
mul_pp r0.w, r1.x, r0
mov r1.x, c3
add r2.x, -c2, r1
abs r2.y, r2.x
add r1.y, -r2.w, c6.x
add r1.y, r1, c8.w
cmp r1.z, r1, c8.y, c8.x
cmp r1.y, r1, c8, c8.x
mul_pp r1.y, r1, r1.z
mul_pp r1.w, r0, r1.y
add r1.xyz, -r0, c0
dp3_pp r1.x, r1, c10
add r1.z, r1.x, -c2.x
cmp r1.y, -r2, c8.x, c8
abs_pp r1.y, r1
rcp r2.x, r2.x
cmp_pp r1.y, -r1, c8.x, c8
abs_pp r0.w, r1
add r1.x, -r1, c8
mul r1.z, r1, r2.x
mul_pp r1.y, r1.w, r1
cmp_pp r1.y, -r1, c8.x, r1.z
cmp_pp oC0.w, -r0, c8.x, r1.y
cmp_pp oC0.xyz, -r0.w, r0, r1.x
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 76 ALU, 1 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.16666667, 1, 0, 9.9999997e-005 },
		{ 2, 4, 6 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0.y, R0.z;
MAX R2.w, R0.x, R0;
MIN R1.x, R0.y, R0.z;
MIN R1.x, R0, R1;
ADD R3.w, R2, -R1.x;
MOV R0.w, c[8].z;
ADD R1, R2.w, -R0;
RCP R2.x, R3.w;
MUL R1, R1, R2.x;
MAX R0.w, c[0].y, c[0].z;
MIN R2.x, c[0].y, c[0].z;
MAX R4.x, R0.w, c[0];
MIN R2.x, R2, c[0];
ADD R0.w, R4.x, -R2.x;
ADD R2.xyz, R1, -R1.zxyw;
RCP R3.x, R0.w;
ADD R1.xyz, R4.x, -c[0];
MUL R1.xyz, R1, R3.x;
ADD R3.xyz, R1, -R1.zxyw;
ADD R2.xyz, R2, c[9];
SGE R1.xyz, R0, R2.w;
MUL R1.xyz, R1, R2.zxyw;
MAX R1.x, R1.z, R1;
MAX R1.x, R1.y, R1;
ADD R3.xyz, R3, c[9];
SGE R2.xyz, c[0], R4.x;
MUL R2.xyz, R2, R3.zxyw;
MAX R1.z, R2, R2.x;
MAX R1.y, R2, R1.z;
ABS R1.z, R0.w;
CMP R2.x, -R1.z, R1.y, c[8].z;
ABS R0.w, R3;
CMP R1.x, -R0.w, R1, c[8].z;
MUL R2.y, R2.x, c[8].x;
MUL R1.y, R1.x, c[8].x;
FRC R2.y, R2;
FRC R1.y, R1;
CMP R1.x, -R0.w, R1.y, R1;
CMP R1.z, -R1, R2.y, R2.x;
ADD R1.x, R1, -R1.z;
RCP R1.y, R1.w;
ABS R1.x, R1;
SLT R1.z, R1.x, c[1].x;
MOV R1.x, c[8].w;
CMP R0.w, -R0, R1.y, c[8].z;
ADD R1.w, R1.x, c[5].x;
ADD R1.y, -R1.x, c[4].x;
SLT R1.w, R0, R1;
SLT R0.w, R1.y, R0;
ADD R1.y, R1.x, c[7].x;
MUL R0.w, R0, R1;
ADD R1.x, -R1, c[6];
MUL R0.w, R1.z, R0;
SLT R1.y, R2.w, R1;
SLT R1.x, R1, R2.w;
MUL R1.x, R1, R1.y;
MUL R1.w, R0, R1.x;
MOV R1.x, c[2];
ADD R2.x, -R1, c[3];
ADD R1.xyz, -R0, c[0];
DP3 R1.y, R1, c[10];
ABS R2.y, R2.x;
ADD R1.z, R1.y, -c[2].x;
ABS R0.w, R1;
CMP R1.x, -R2.y, c[8].z, c[8].y;
ABS R1.x, R1;
RCP R2.x, R2.x;
CMP R1.x, -R1, c[8].z, c[8].y;
CMP R0.w, -R0, c[8].z, c[8].y;
ADD R1.y, -R1, c[8];
MUL R1.z, R1, R2.x;
MUL R1.x, R1.w, R1;
CMP R1.x, -R1, R1.z, c[8].y;
CMP result.color.w, -R0, c[8].y, R1.x;
CMP result.color.xyz, -R0.w, R0, R1.y;
END
# 76 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 80 ALU, 1 TEX
dcl_2d s0
def c8, 1.00000000, 0.00000000, 0.16666667, -0.00010000
def c9, 2.00000000, 4.00000000, 6.00000000, 0
def c10, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
texld r0.xyz, v0, s0
max r0.w, r0.y, r0.z
max r2.w, r0.x, r0
min r1.x, r0.y, r0.z
min r1.x, r0, r1
add r3.w, r2, -r1.x
mov r0.w, c8.y
add r1, r2.w, -r0
rcp r2.x, r3.w
mul r1, r1, r2.x
max r0.w, c0.y, c0.z
max r4.x, r0.w, c0
add r1.xyz, r1, -r1.zxyw
min r2.x, c0.y, c0.z
min r2.x, r2, c0
add r0.w, r4.x, -r2.x
add r2.xyz, -r2.w, r0
rcp r4.y, r0.w
add r3.xyz, r4.x, -c0
mul r3.xyz, r3, r4.y
add r3.xyz, r3, -r3.zxyw
cmp r2.xyz, r2, c8.x, c8.y
add r1.xyz, r1, c9
mul r1.xyz, r2, r1.zxyw
max r1.x, r1.z, r1
add r2.xyz, -r4.x, c0
max r1.x, r1.y, r1
add r3.xyz, r3, c9
cmp r2.xyz, r2, c8.x, c8.y
mul r2.xyz, r2, r3.zxyw
max r1.z, r2, r2.x
max r1.y, r2, r1.z
abs r1.z, r0.w
cmp r2.x, -r1.z, c8.y, r1.y
abs r0.w, r3
cmp r1.x, -r0.w, c8.y, r1
mul r2.y, r2.x, c8.z
mul r1.y, r1.x, c8.z
frc r2.y, r2
frc r1.y, r1
cmp r1.z, -r1, r2.x, r2.y
cmp r1.x, -r0.w, r1, r1.y
add r1.x, r1, -r1.z
abs r1.y, r1.x
rcp r1.x, r1.w
add r1.z, r2.w, -c7.x
add r1.z, r1, c8.w
cmp r0.w, -r0, c8.y, r1.x
add r1.y, r1, -c1.x
cmp r1.x, r1.y, c8.y, c8
add r1.y, r0.w, -c5.x
add r0.w, -r0, c4.x
add r1.y, r1, c8.w
add r0.w, r0, c8
cmp r1.y, r1, c8, c8.x
cmp r0.w, r0, c8.y, c8.x
mul_pp r0.w, r0, r1.y
mul_pp r0.w, r1.x, r0
mov r1.x, c3
add r2.x, -c2, r1
abs r2.y, r2.x
add r1.y, -r2.w, c6.x
add r1.y, r1, c8.w
cmp r1.z, r1, c8.y, c8.x
cmp r1.y, r1, c8, c8.x
mul_pp r1.y, r1, r1.z
mul_pp r1.w, r0, r1.y
add r1.xyz, -r0, c0
dp3_pp r1.x, r1, c10
add r1.z, r1.x, -c2.x
cmp r1.y, -r2, c8.x, c8
abs_pp r1.y, r1
rcp r2.x, r2.x
cmp_pp r1.y, -r1, c8.x, c8
abs_pp r0.w, r1
add r1.x, -r1, c8
mul r1.z, r1, r2.x
mul_pp r1.y, r1.w, r1
cmp_pp r1.y, -r1, c8.x, r1.z
cmp_pp oC0.w, -r0, c8.x, r1.y
cmp_pp oC0.xyz, -r0.w, r0, r1.x
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 76 ALU, 1 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.16666667, 1, 0, 9.9999997e-005 },
		{ 2, 4, 6 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0.y, R0.z;
MAX R2.w, R0.x, R0;
MIN R1.x, R0.y, R0.z;
MIN R1.x, R0, R1;
ADD R3.w, R2, -R1.x;
MOV R0.w, c[8].z;
ADD R1, R2.w, -R0;
RCP R2.x, R3.w;
MUL R1, R1, R2.x;
MAX R0.w, c[0].y, c[0].z;
MIN R2.x, c[0].y, c[0].z;
MAX R4.x, R0.w, c[0];
MIN R2.x, R2, c[0];
ADD R0.w, R4.x, -R2.x;
ADD R2.xyz, R1, -R1.zxyw;
RCP R3.x, R0.w;
ADD R1.xyz, R4.x, -c[0];
MUL R1.xyz, R1, R3.x;
ADD R3.xyz, R1, -R1.zxyw;
ADD R2.xyz, R2, c[9];
SGE R1.xyz, R0, R2.w;
MUL R1.xyz, R1, R2.zxyw;
MAX R1.x, R1.z, R1;
MAX R1.x, R1.y, R1;
ADD R3.xyz, R3, c[9];
SGE R2.xyz, c[0], R4.x;
MUL R2.xyz, R2, R3.zxyw;
MAX R1.z, R2, R2.x;
MAX R1.y, R2, R1.z;
ABS R1.z, R0.w;
CMP R2.x, -R1.z, R1.y, c[8].z;
ABS R0.w, R3;
CMP R1.x, -R0.w, R1, c[8].z;
MUL R2.y, R2.x, c[8].x;
MUL R1.y, R1.x, c[8].x;
FRC R2.y, R2;
FRC R1.y, R1;
CMP R1.x, -R0.w, R1.y, R1;
CMP R1.z, -R1, R2.y, R2.x;
ADD R1.x, R1, -R1.z;
RCP R1.y, R1.w;
ABS R1.x, R1;
SLT R1.z, R1.x, c[1].x;
MOV R1.x, c[8].w;
CMP R0.w, -R0, R1.y, c[8].z;
ADD R1.w, R1.x, c[5].x;
ADD R1.y, -R1.x, c[4].x;
SLT R1.w, R0, R1;
SLT R0.w, R1.y, R0;
ADD R1.y, R1.x, c[7].x;
MUL R0.w, R0, R1;
ADD R1.x, -R1, c[6];
MUL R0.w, R1.z, R0;
SLT R1.y, R2.w, R1;
SLT R1.x, R1, R2.w;
MUL R1.x, R1, R1.y;
MUL R1.w, R0, R1.x;
MOV R1.x, c[2];
ADD R2.x, -R1, c[3];
ADD R1.xyz, -R0, c[0];
DP3 R1.y, R1, c[10];
ABS R2.y, R2.x;
ADD R1.z, R1.y, -c[2].x;
ABS R0.w, R1;
CMP R1.x, -R2.y, c[8].z, c[8].y;
ABS R1.x, R1;
RCP R2.x, R2.x;
CMP R1.x, -R1, c[8].z, c[8].y;
CMP R0.w, -R0, c[8].z, c[8].y;
ADD R1.y, -R1, c[8];
MUL R1.z, R1, R2.x;
MUL R1.x, R1.w, R1;
CMP R1.x, -R1, R1.z, c[8].y;
CMP result.color.w, -R0, c[8].y, R1.x;
CMP result.color.xyz, -R0.w, R0, R1.y;
END
# 76 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_ChromaKey]
Float 1 [_HueThreshold]
Float 2 [_MinShadeDarkness]
Float 3 [_MaxShadeDarkness]
Float 4 [_MinSaturation]
Float 5 [_MaxSaturation]
Float 6 [_MinLightness]
Float 7 [_MaxLightness]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 80 ALU, 1 TEX
dcl_2d s0
def c8, 1.00000000, 0.00000000, 0.16666667, -0.00010000
def c9, 2.00000000, 4.00000000, 6.00000000, 0
def c10, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
texld r0.xyz, v0, s0
max r0.w, r0.y, r0.z
max r2.w, r0.x, r0
min r1.x, r0.y, r0.z
min r1.x, r0, r1
add r3.w, r2, -r1.x
mov r0.w, c8.y
add r1, r2.w, -r0
rcp r2.x, r3.w
mul r1, r1, r2.x
max r0.w, c0.y, c0.z
max r4.x, r0.w, c0
add r1.xyz, r1, -r1.zxyw
min r2.x, c0.y, c0.z
min r2.x, r2, c0
add r0.w, r4.x, -r2.x
add r2.xyz, -r2.w, r0
rcp r4.y, r0.w
add r3.xyz, r4.x, -c0
mul r3.xyz, r3, r4.y
add r3.xyz, r3, -r3.zxyw
cmp r2.xyz, r2, c8.x, c8.y
add r1.xyz, r1, c9
mul r1.xyz, r2, r1.zxyw
max r1.x, r1.z, r1
add r2.xyz, -r4.x, c0
max r1.x, r1.y, r1
add r3.xyz, r3, c9
cmp r2.xyz, r2, c8.x, c8.y
mul r2.xyz, r2, r3.zxyw
max r1.z, r2, r2.x
max r1.y, r2, r1.z
abs r1.z, r0.w
cmp r2.x, -r1.z, c8.y, r1.y
abs r0.w, r3
cmp r1.x, -r0.w, c8.y, r1
mul r2.y, r2.x, c8.z
mul r1.y, r1.x, c8.z
frc r2.y, r2
frc r1.y, r1
cmp r1.z, -r1, r2.x, r2.y
cmp r1.x, -r0.w, r1, r1.y
add r1.x, r1, -r1.z
abs r1.y, r1.x
rcp r1.x, r1.w
add r1.z, r2.w, -c7.x
add r1.z, r1, c8.w
cmp r0.w, -r0, c8.y, r1.x
add r1.y, r1, -c1.x
cmp r1.x, r1.y, c8.y, c8
add r1.y, r0.w, -c5.x
add r0.w, -r0, c4.x
add r1.y, r1, c8.w
add r0.w, r0, c8
cmp r1.y, r1, c8, c8.x
cmp r0.w, r0, c8.y, c8.x
mul_pp r0.w, r0, r1.y
mul_pp r0.w, r1.x, r0
mov r1.x, c3
add r2.x, -c2, r1
abs r2.y, r2.x
add r1.y, -r2.w, c6.x
add r1.y, r1, c8.w
cmp r1.z, r1, c8.y, c8.x
cmp r1.y, r1, c8, c8.x
mul_pp r1.y, r1, r1.z
mul_pp r1.w, r0, r1.y
add r1.xyz, -r0, c0
dp3_pp r1.x, r1, c10
add r1.z, r1.x, -c2.x
cmp r1.y, -r2, c8.x, c8
abs_pp r1.y, r1
rcp r2.x, r2.x
cmp_pp r1.y, -r1, c8.x, c8
abs_pp r0.w, r1
add r1.x, -r1, c8
mul r1.z, r1, r2.x
mul_pp r1.y, r1.w, r1
cmp_pp r1.y, -r1, c8.x, r1.z
cmp_pp oC0.w, -r0, c8.x, r1.y
cmp_pp oC0.xyz, -r0.w, r0, r1.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}

#LINE 110

	} 

	FallBack "Unlit/Diffuse"
}