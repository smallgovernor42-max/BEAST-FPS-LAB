#include <metal_stdlib>
using namespace metal;

struct ArenaVertex {
    float3 position;
    float3 color;
};

struct ArenaUniforms {
    float4x4 mvp;
};

struct ArenaOutput {
    float4 position [[position]];
    float3 color;
};

vertex ArenaOutput arena_vertex_main(
    const device ArenaVertex* vertices [[buffer(0)]],
    constant ArenaUniforms& uniforms [[buffer(1)]],
    uint vertexID [[vertex_id]]
) {
    ArenaOutput output;

    ArenaVertex vertex = vertices[vertexID];

    output.position = uniforms.mvp * float4(
        vertex.position,
        1.0
    );

    output.color = vertex.color;

    return output;
}

fragment float4 arena_fragment_main(
    ArenaOutput input [[stage_in]]
) {
    return float4(input.color, 1.0);
}
