#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_main(
    uint vertexID [[vertex_id]]
) {
    float2 positions[] = {
        float2(-0.5, -0.5),
        float2( 0.5, -0.5),
        float2( 0.0,  0.5)
    };

    VertexOut output;

    output.position = float4(
        positions[vertexID],
        0.0,
        1.0
    );

    output.color = float4(
        0.0,
        1.0,
        0.2,
        1.0
    );

    return output;
}

fragment float4 fragment_main(
    VertexOut input [[stage_in]]
) {
    return input.color;
}
