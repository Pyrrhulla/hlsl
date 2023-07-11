float3 rayStep = viewDir * -1;
float4 color;

struct texDistort
{
    float2 texScale(float2 uv, float2 scale)
    {
        float2 texScale = (uv - 0.5) * scale + 0.5;
        return texScale;
    }

    float2 texRotate(float2 uv, float angle)
    {
        float2x2 rotationMatrix = float2x2 (cos(angle), sin(angle), -sin(angle), cos(angle));
        return mul(uv - 0.5, rotationMatrix) + 0.5;
    }

    float2 texDistortion(float2 uv, float time)
    {
        float angle = atan2(uv.y - 0.5, uv.x - 0.5);
        float radius = length(uv - 0.5);

        float distortion = 4 * sin(3 * radius + 2 * time);
        float primDist = sin(6.0 * angle) * distortion;

        return texRotate(uv, primDist);
    }
};
texDistort txd;

for (int i = 0; i < 5; i++)
{
    color = Texture2DSample(texObject, texObjectSampler, txd.texDistortion(uv, time));

    if(color.r > 0.1 && color.g > 0.1 && color.b > 0.1)
    {
        return color * float3(1, 0, 0);
    }
    else if(color.r > 0.01 && color.g > 0.01 && color.b > 0.01)
    {
        return color * float3(0, 1, 1);
    }
    uv += rayStep * 1.5;
}


return(color);