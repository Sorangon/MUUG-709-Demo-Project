inline float2 Panner(float2 uv, float2 direction)
{
    return uv + direction * _Time;
}

inline fixed Dissolve(float texAlpha, float amount)
{
    return clamp(ceil(texAlpha - amount), 0,1);
}
