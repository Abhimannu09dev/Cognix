// src/main/java/com/cognix/model/ReportData.java
package com.cognix.model;

import java.util.List;

/** Simple holder for chart data */
public class ReportData<T> {
  private final List<String> labels;
  private final List<T>      data;
  public ReportData(List<String> labels, List<T> data) {
    this.labels = labels; this.data = data;
  }
  public List<String> getLabels() { return labels; }
  public List<T>      getData()   { return data;   }
}
