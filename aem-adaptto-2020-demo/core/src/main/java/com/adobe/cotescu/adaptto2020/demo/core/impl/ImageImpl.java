package com.adobe.cotescu.adaptto2020.demo.core.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.models.annotations.Exporter;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.Via;
import org.apache.sling.models.annotations.injectorspecific.Self;
import org.apache.sling.models.annotations.via.ResourceSuperType;

import com.adobe.cotescu.adaptto2020.demo.core.Image;
import com.adobe.cq.export.json.ComponentExporter;
import com.adobe.cq.export.json.ExporterConstants;
import com.adobe.cq.wcm.core.components.models.ImageArea;
import com.adobe.cq.wcm.core.components.models.datalayer.ComponentData;

@Model(
        adaptables = SlingHttpServletRequest.class,
        adapters = {Image.class, ComponentExporter.class},
        resourceType = ImageImpl.RESOURCE_TYPE
)
@Exporter(name = ExporterConstants.SLING_MODEL_EXPORTER_NAME, extensions = ExporterConstants.SLING_MODEL_EXTENSION)
public class ImageImpl implements Image {

    public static final String RESOURCE_TYPE = "aem-adaptto-2020-demo/components/image";

    @Self @Via(type = ResourceSuperType.class)
    private com.adobe.cq.wcm.core.components.models.Image delegate;

    private List<String> sourceSet = new ArrayList<>();

    @PostConstruct
    private void init() {
        if (StringUtils.isNotEmpty(delegate.getSrcUriTemplate()) && delegate.getWidths().length > 0) {
            for (int width : delegate.getWidths()) {
                sourceSet.add(String.format("%s %s", delegate.getSrcUriTemplate().replace("{.width}", "." + width), width + "w"));
            }
        }
    }

    @Override
    public List<String> getSourceSet() {
        return new ArrayList<>(sourceSet);
    }

    @Override
    public String getSrc() {
        return delegate.getSrc();
    }

    @Override
    public String getAlt() {
        return delegate.getAlt();
    }

    @Override
    public String getTitle() {
        return delegate.getTitle();
    }

    @Override
    public String getUuid() {
        return delegate.getUuid();
    }

    @Override
    public String getLink() {
        return delegate.getLink();
    }

    @Override
    public boolean displayPopupTitle() {
        return delegate.displayPopupTitle();
    }

    @Override
    public String getFileReference() {
        return delegate.getFileReference();
    }

    @Override
    public String getJson() {
        return delegate.getJson();
    }

    @Override
    public int[] getWidths() {
        return delegate.getWidths();
    }

    @Override
    public String getSrcUriTemplate() {
        return delegate.getSrcUriTemplate();
    }

    @Override
    public boolean isLazyEnabled() {
        return false;
    }

    @Override
    public int getLazyThreshold() {
        return delegate.getLazyThreshold();
    }

    @Override
    public List<ImageArea> getAreas() {
        return delegate.getAreas();
    }

    @Override
    public String getExportedType() {
        return delegate.getExportedType();
    }

    @Override
    public boolean isDecorative() {
        return delegate.isDecorative();
    }

    @Override
    public String getId() {
        return delegate.getId();
    }

    @Override
    public ComponentData getData() {
        return delegate.getData();
    }
}
