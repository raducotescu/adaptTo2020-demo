package com.adobe.cotescu.adaptto2020.demo.core;

import java.util.Collections;
import java.util.List;

import org.osgi.annotation.versioning.ConsumerType;

@ConsumerType
public interface Image extends com.adobe.cq.wcm.core.components.models.Image {

    /**
     * Returns a list of image descriptions with which the {@code srcset} attribute of the {@code <source>} elements of a {@code <picture>}
     * tag can be populated.
     *
     * @return the list of image descriptions
     */
    default List<String> getSourceSet() {
        return Collections.emptyList();
    }

}
