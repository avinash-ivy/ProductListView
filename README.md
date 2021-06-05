# ProductListView
**Problem Statement:** To show a list of products and when clicked on a specific product, its details page to be shown.

**How to run:** Open TargetCaseStudy.xcworkspace. Select ProductViewer target and desired iphone simulator. Click on Run button. In case you want to use mock data, you can change the arugement in below line of code to ```.mock```

``` let dataService = DataService(dataSource: .network) ```

**Architecture:** Tempo. 

This architecture follows Unidirectional data flow model and makes it simple to update complex views.

**Components:**

  - ProductList
  - ProductDetail
  - Service
  - Utility

**Service**

Service component contains entities that are related to data fetching. Data is fetched from either **network** or **file** with mocked data. This component is written abstractly so that it can be expanded to different kind of data fetching techniques.

**Utility**

Utility component contains couple of classes for image caching. NSCache is used to store the cached images mapped to urls.

**ProductList**

Most of the entities are provided deafult in the project provided. A few changes are done to get the data from Service struct. To support few UI components which are not provided by default.

**DetailList**

Entities in this component are written following the Tempo Architecture. Since, details page doesn't have a complex UI, component part of tempo is ignored here. Component duty is delegated to Presenter. 

**Screenshots**

<img src="https://github.com/avinash-ivy/ProductListView/blob/main/TempoProductList.png"
  alt="Tempo Detail"
  width="289" height="600">
</p>

<img src="https://github.com/avinash-ivy/ProductListView/blob/main/TempoDetail.png"
  alt="Tempo Detail"
  width="289" height="600">
</p>
