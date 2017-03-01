#pragma once
#include "oxygine-include.h"
#include "Sprite.h"

namespace oxygine
{
    DECLARE_SMART(ColorRectSprite, spColorRectSprite);

    class ColorRectSprite: public Sprite
    {
        INHERITED(Sprite);
    public:
        DECLARE_COPYCLONE_NEW(ColorRectSprite);
        ColorRectSprite();
        ~ColorRectSprite();

        void serialize(serializedata* data) override;
        void deserialize(const deserializedata* data) override;

        void doRender(const RenderState& rs) override;
    };
}

EDITOR_INCLUDE(ColorRectSprite);