<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Seller Models – Cognix</title>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        
  <style>
  /* === Reset & Base === */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
html, body {
  height: 100%;
  overflow: hidden;            /* disable top‐level scrolling */
}
body {
  font-family: 'Helvetica Neue', sans-serif;
  background: #F1EDE9;
  color: #222;
}

/* === Dashboard Layout === */
.dashboard {
  display: flex;
  max-width: 1440px;
  height: 100%;
  margin: 0 auto;
}
.dashboard__nav {
  width: 280px;
  position: fixed;
  top: 0; left: 0;
  height: 100%;
  background: #fff;
  overflow-y: auto;
  scrollbar-width: none;       /* Firefox */
}
.dashboard__nav::-webkit-scrollbar {
  width: 0;                     /* Chrome/Safari */
}
.dashboard__main {
  margin-left: 280px;           /* make room for fixed nav */
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 100%;
}

/* === Scrollable Content === */
.dashboard__content {
  flex: 1;
  padding: 1rem 2rem;
  padding-top: 4rem;           /* for any topbar */
  overflow-y: auto;
  scrollbar-width: none;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}
.dashboard__content::-webkit-scrollbar {
  width: 0;
}

/* === Topbar (if used) === */
.dashboard__topbar {
  position: absolute;
  top: 0; left: 280px;
  right: 0;
  padding: 1rem 2rem;
  background: #F1EDE9;
  z-index: 10;
}

/* === Stats Overview & Models Section === */
.stats-overview, .models-section {
  background: #fff;
  border-radius: 16px;
  padding: 1.5rem;
}
.stats-overview h2,
.models-section h2 {
  font-size: 1.25rem;
  margin-bottom: 1rem;
  color: #222;
}
.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}
.stat-card {
  background: #fafafa;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 1rem;
}
.stat-card p {
  font-size: .75rem;
  color: #666;
}
.stat-card h3 {
  margin-top: .5rem;
  font-size: .875rem;
  color: #222;
}

/* === Controls Bar === */
.controls {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
  padding: 0 1rem 1rem;
}
.search-bar {
  flex: 1;
  display: flex;
  align-items: center;
  color: #666;
}
.search-bar i {
  margin-right: .5rem;
}
.search-bar input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 1rem;
  outline: none;
}
.filter-dropdown select,
.filter-dropdown input[type="date"] {
  border: 1px solid #ddd;
  background: #fafafa;
  border-radius: 8px;
  padding: .5rem 1rem;
  font-size: .95rem;
  color: #444;
  cursor: pointer;
}
.apply-btn, .add-btn {
  padding: .5rem 1rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background .2s;
}
.apply-btn {
  background: #111;
  color: #fff;
}
.apply-btn:hover {
  background: #333;
}
.add-btn {
  background: #28a745;
  color: #fff;
}
.add-btn:hover {
  background: #218838;
}

/* === Models Table === */
.table-wrapper {
  overflow-x: auto;
}
.models-table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
}
.models-table th,
.models-table td {
  padding: .75rem 1rem;
  text-align: left;
  border-bottom: 1px solid #f5f5f5;
}
.models-table th {
  background: #fafafa;
  font-size: .85rem;
  color: #666;
}
.models-table th:first-child,
.models-table td:first-child {
  width: 50px;
}
/* Sales (6th) and Revenue (7th) columns */
.models-table th:nth-child(6),
.models-table td:nth-child(6),
.models-table th:nth-child(7),
.models-table td:nth-child(7) {
  width: 75px;
}

/* === Modal Common Styles === */
.modal-add {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  display: none;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}
.modal-add.show {
  display: flex;
}
.modal-add .modal-content {
  position: relative;
  background: #fff;
  border-radius: 8px;
  width: 90%;
  max-width: 900px;
  padding: 2rem;
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
  max-height: 90vh;
  overflow-y: auto;
}
.modal-close {
  position: absolute;
  top: 1rem; right: 1rem;
  background: transparent;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
}
.modal-add h2 {
  margin-bottom: 1rem;
  font-size: 1.5rem;
}
.form-group {
  margin-bottom: .75rem;
  text-align: left;
}
.form-group label {
  display: block;
  margin-bottom: .25rem;
  font-weight: bold;
}
.form-group input,
.form-group textarea {
  width: 100%;
  padding: .5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: .9rem;
}
.form-group textarea {
  resize: vertical;
}

/* === Image Upload & Preview === */
.image-group {
  display: flex;
  gap: 2rem;
  align-items: flex-start;
}
.upload-area {
  flex: 0 0 160px;
  border: 2px dashed #ddd;
  border-radius: 4px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  color: #888;
  cursor: pointer;
  position: relative;
  transition: background .2s;
}
.upload-area:hover {
  background: #fafafa;
}
.upload-area input {
  position: absolute;
  width: 100%; height: 100%;
  top: 0; left: 0;
  opacity: 0;
  cursor: pointer;
}
.upload-area .fa-cloud-upload-alt {
  font-size: 1.8rem;
  margin-bottom: .5rem;
}
.banner-preview {
  flex: 0 0 200px;
  height: 200px;
  overflow: hidden;
}
.banner-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #eee;
}

/* === Form Actions & Buttons === */
.form-actions {
  text-align: right;
  margin-top: 1rem;
}
.btn-submit {
  background: #111;
  color: #fff;
  border: none;
  padding: .75rem 1.5rem;
  border-radius: 4px;
  cursor: pointer;
  transition: background .2s;
}
.btn-submit:hover {
  background: #333;
}
.edit-btn, .delete-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  color: #fff;
}
.edit-btn {
  background: #007bff;
}
.delete-btn {
  background: #dc3545;
}

/* === Delete Confirmation Modal === */
#confirmDeleteModal .modal-content {
  max-width: 400px;
  text-align: center;
}
#confirmDeleteModal h2 {
  margin-bottom: .5rem;
}
#confirmDeleteModal p {
  margin-bottom: 1rem;
}
#confirmDeleteModal .form-actions {
  display: flex;
  gap: 1rem;
}
#confirmDeleteModal .apply-btn {
  flex: 1;
}
#confirmDeleteModal .apply-btn:first-child {
  background: #dc3545;
}
#confirmDeleteModal .apply-btn:last-child {
  background: #666;
}

/* === Footer Inside Content === */
.page-footer,
.dashboard__main > footer {
  margin-top: 2rem;
  text-align: center;
  color: #666;
  font-size: .85rem;
}
  



  </style>
</head>
<body>

<div class="dashboard">
  <aside class="dashboard__nav">
    <%@ include file="/WEB-INF/pages/component/SellerNav.jsp" %>
  </aside>

  <div class="dashboard__main">

    <div class="dashboard__content">
    
    <h1>Models Listing</h1>

      <!-- Stats Overview -->
      <section class="stats-overview">
        <h2>Stats Overview</h2>
        <div class="stats-cards">
          <div class="stat-card">
            <p>Total Listings</p>
            <h3>${empty modelsList ? 0 : fn:length(modelsList)}</h3>
          </div>
          <div class="stat-card">
            <p>Total Sales</p>
            <h3>${empty totalSales ? 0 : totalSales}</h3>
          </div>
          <div class="stat-card">
            <p>Total Earnings</p>
            <h3>$${empty totalRevenue ? 0 : totalRevenue}</h3>
          </div>
          <div class="stat-card">
            <p>Most Popular Model</p>
            <h3>${empty mostPopularModelName ? 'None' : mostPopularModelName}</h3>
          </div>
        </div>
      </section>

      <!-- Models Section -->
      <section class="models-section">
        <h2>Listed Models</h2>

        <!-- Filters + Add -->
        <form method="get" class="controls">
          <div class="search-bar" style="border-bottom:1px solid #ddd;padding-bottom:1rem;">
            <i class="fas fa-search"></i>
            <input name="search" type="text" placeholder="Search…"/>
          </div>
          <div class="filter-dropdown">
		  <select name="modelType">
		    <option value="">All Types</option>
		    <c:forEach var="cat" items="${categoriesList}">
		      <option value="${fn:escapeXml(cat)}"
		        <c:if test="${param.modelType == cat}">selected</c:if>>
		        ${fn:escapeXml(cat)}
		      </option>
		    </c:forEach>
		  </select>
		</div>
          <div class="filter-dropdown">
            <input type="date" name="postedAt"/>
          </div>
          <button type="submit" class="apply-btn">Apply</button>
          <button type="button" id="openAdd" class="add-btn">+ Add Model</button>
        </form>

        <!-- Model Table -->
        <div class="table-wrapper">
          <table class="models-table">
            <thead>
              <tr>
                <th>SN</th><th>Name</th><th>Category</th>
                <th>Listed</th><th>Price</th><th>Sales</th>
                <th>Revenue</th><th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="model" items="${modelsList}" varStatus="status">
                <tr>
                  <td>${status.index + 1}</td>
                  <td class="col-name">${fn:escapeXml(model.name)}</td>
                  <td class="col-category">${fn:escapeXml(model.category)}</td>
                  <td class="col-listed">
                    <fmt:formatDate value="${model.listedDate}" pattern="yyyy-MM-dd"/>
                  </td>
                  <td class="col-price">$${model.price}</td>
                  <td class="col-sales">${model.sales}</td>
                  <td class="col-revenue">$${model.revenue}</td>
                  <td style="display:flex; gap:1rem;">
                  <a href="?editId=${model.modelId}"
					   class="edit-btn"
					   style="background:#007bff;color:#fff;padding:6px 12px;border-radius:6px;text-decoration:none;">
					  Edit
					</a>
					<button
					  type="button"
					  class="delete-btn"
					  data-delete-url="${pageContext.request.contextPath}/DeleteModel?id=${model.modelId}">
					  Delete
					</button>
					
					
					</td>
                  
                  
                </tr>
              </c:forEach>
              <c:if test="${empty modelsList}">
                <tr><td colspan="8" style="text-align:center;">No models found.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </section>
      
    <footer>
      <jsp:include page="/WEB-INF/pages/component/CopyRight.jsp"/>
    </footer>

    </div>


  </div>
</div>

<!-- ── ADD MODEL MODAL ── -->
<div id="modalAdd" class="modal-add">
  <div class="modal-content">
    <button class="modal-close" id="closeAdd">&times;</button>
    <h2>Add New Model</h2>
    <form action="${pageContext.request.contextPath}/AddModel"
      method="post"
      enctype="multipart/form-data">
      <div class="form-group">
        <label for="name">Name</label>
        <input id="name" name="name" type="text" required>
      </div>
      <div class="form-group">
        <label for="version">Version</label>
        <input id="version" name="version" type="text" required>
      </div>
      <div class="form-group">
        <label for="category">Category</label>
        <input id="category" name="category" type="text" required>
      </div>
      <div class="form-group">
        <label for="docsUrl">Docs URL</label>
        <input id="docsUrl" name="docsUrl" type="url">
      </div>
      <div class="form-group">
        <label for="modelUrl">Model URL</label>
        <input id="modelUrl" name="modelUrl" type="url">
      </div>
      <div class="form-group">
        <label for="description">Description</label>
        <textarea id="description" name="description" rows="3" required></textarea>
      </div>
      
      <div class="form-group image-group">
	  <!-- left: the dashed upload area -->
	  <label for="imageInput">Model Image</label>
	  <div class="upload-area" onclick="imageInput.click()">
	    <i class="fas fa-cloud-upload-alt"></i>
	    <div class="text">
	      <strong>Click to upload</strong><br>
	      or drag &amp; drop<br>
	      PNG, JPG, GIF
	    </div>
	    <input id="imageInput" name="image"
	           type="file" accept="image/*">
	  </div>
	
	  <!-- right: the preview pane -->
	  <div class="banner-preview">
	    <img id="bannerImg"
	         src="${pageContext.request.contextPath}/uploads/${model.imagePath}"
	         alt="Preview">
	  </div>
	</div>
      
      <div class="form-group">
        <label for="price">Price (USD)</label>
        <input id="price" name="price" type="number" step="0.01" required>
      </div>
      <div class="form-group">
        <label for="accuracy">Accuracy</label>
        <input id="accuracy" name="accuracy" type="text">
      </div>
      <div class="form-group">
        <label for="precision">Precision</label>
        <input id="precision" name="precision" type="number">
      </div>
      <div class="form-group">
        <label for="recall">Recall</label>
        <input id="recall" name="recall" type="text">
      </div>
      <div class="form-group">
        <label for="f1score">F1 Score</label>
        <input id="f1score" name="f1Score" type="text">
      </div>
      <div class="form-group">
        <label for="parameters">Parameters</label>
        <input id="parameters" name="parameters" type="text">
      </div>
      <div class="form-group">
        <label for="inferenceTime">Inference Time</label>
        <input id="inferenceTime" name="inferenceTime" type="text">
      </div>
      <div class="form-actions">
        <button type="submit" class="btn-submit">Add Model</button>
      </div>
    </form>
  </div>
</div>

<!-- ── EDIT MODEL MODAL (server-side) ── -->
<c:if test="${not empty param.editId}">
  <c:forEach var="model" items="${modelsList}">
    <c:if test="${model.modelId == fn:trim(param.editId)}">
      <div id="modalEdit" class="modal-add show">
        <div class="modal-content">
        
                  <!-- 1) Close “×” button: type="button", no href -->
          <button
            type="button"
            class="modal-close"
            id="closeEdit">&times;</button>

          <h2>Edit Model</h2>
          <form action="${pageContext.request.contextPath}/EditModel"
                method="post"
                enctype="multipart/form-data">
            <input type="hidden" name="modelId" value="${model.modelId}"/>
            <input type="hidden" name="existingImagePath"
                   value="${model.imagePath}"/>

            <div class="form-group">
              <label>Name</label>
              <input name="name" type="text"
                     value="${fn:escapeXml(model.name)}" required/>
            </div>
            <div class="form-group">
              <label>Version</label>
              <input name="version" type="text"
                     value="${fn:escapeXml(model.version)}" required/>
            </div>
            <div class="form-group">
              <label>Category</label>
              <input name="category" type="text"
                     value="${fn:escapeXml(model.category)}" required/>
            </div>
            <div class="form-group">
              <label>Docs URL</label>
              <input name="docsUrl" type="url"
                     value="${fn:escapeXml(model.docsUrl)}"/>
            </div>
            <div class="form-group">
              <label>Model URL</label>
              <input name="modelUrl" type="url"
                     value="${fn:escapeXml(model.githubUrl)}"/>
            </div>
            <div class="form-group">
              <label>Description</label>
              <textarea name="description" rows="3" required>${fn:escapeXml(model.description)}</textarea>
            </div>
            
            <div class="form-group image-group">
			  <label>Model Image</label>
			  <!-- store the existing filename so servlet can reuse if no new upload -->
			  <input 
			    type="hidden" 
			    name="existingImagePath" 
			    value="${fn:escapeXml(model.imagePath)}"/>
			
			  <!-- dashed area that opens the real file chooser -->
			  <div 
			    class="upload-area" 
			    onclick="document.getElementById('editImageInput').click()">
			    <i class="fas fa-cloud-upload-alt"></i>
			    <div class="text">
			      Current image shown; upload to replace
			    </div>
			    <input
			      id="editImageInput"
			      name="image"
			      type="file"
			      accept="image/*"
			      style="opacity:0; position:absolute; inset:0; cursor:pointer;"/>
			  </div>
			
			  <!-- preview pane always points at /uploads/<filename> -->
			  <div class="banner-preview">
			    <img
			      id="editBannerImg"
			      src="${pageContext.request.contextPath}/uploads/${model.imagePath}"
			      alt="Current model image"
			      style="
			        width: 200px;
			        height: 200px;
			        object-fit: cover;
			        border: 1px solid #eee;
			        border-radius: 4px;
			      "/>
			  </div>
			</div>
            
            

            <div class="form-group">
              <label>Price (USD)</label>
              <input name="price" type="number" step="0.01"
                     value="${model.price}" required/>
            </div>
            <div class="form-group">
              <label>Accuracy</label>
              <input name="accuracy" type="text"
                     value="${model.accuracy}"/>
            </div>
            <div class="form-group">
              <label>Precision</label>
              <input name="precision" type="number"
                     value="${model.precision}"/>
            </div>
            <div class="form-group">
              <label>Recall</label>
              <input name="recall" type="text"
                     value="${model.recall}"/>
            </div>
            <div class="form-group">
              <label>F1 Score</label>
              <input name="f1Score" type="text"
                     value="${model.f1Score}"/>
            </div>
            <div class="form-group">
              <label>Parameters</label>
              <input name="parameters" type="text"
                     value="${model.parameters}"/>
            </div>
            <div class="form-group">
              <label>Inference Time (ms)</label>
              <input name="inferenceTime" type="text"
                     value="${model.inferenceTime}"/>
            </div>

            <div class="form-actions">
              <button type="submit" class="apply-btn">Save Changes</button>
              <!-- 2) Cancel button: type="button" -->
              <button
                type="button"
                class="apply-btn"
                id="cancelEdit"
                style="margin-left:1rem;">
                Cancel
              </button>
            </div>
          </form>
        </div>
      </div>
    </c:if>
  </c:forEach>
</c:if>

  <!-- ── MODALS ── -->
  <div id="modalAdd" class="modal-add">
    <div class="modal-content">
      <button class="modal-close" id="closeAdd">&times;</button>
      <h2>Add New Model</h2>
      <!-- your AddModel form here -->
    </div>
  </div>

  <div id="modalEdit" class="modal-add">
    <div class="modal-content">
      <button class="modal-close" id="closeEdit">&times;</button>
      <h2>Edit Model</h2>
      <!-- your EditModel form here -->
    </div>
  </div>

  <div id="confirmDeleteModal" class="modal-add">
    <div class="modal-content" style="max-width:400px; text-align:center;">
      <h2>Confirm Deletion</h2>
      <p>Are you sure you want to delete this model?</p>
      <div class="form-actions" style="display:flex; gap:1rem; margin-top:1rem;">
        <button type="button" id="confirmYes" class="apply-btn" style="flex:1; background:#dc3545;">
          Yes
        </button>
        <button type="button" id="confirmNo" class="apply-btn" style="flex:1; background:#666;">
          No
        </button>
      </div>
    </div>
  </div>

  <!-- ── ALL MODAL LOGIC ── -->
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      //
      // ── ADD MODEL MODAL + PREVIEW ──
      //
      const openAdd    = document.getElementById('openAdd');
      const closeAdd   = document.getElementById('closeAdd');
      const modalAdd   = document.getElementById('modalAdd');
      const imgInAdd   = document.getElementById('imageInput');
      const prevAdd    = document.getElementById('bannerImg');

      openAdd.addEventListener('click', () => modalAdd.classList.add('show'));
      closeAdd.addEventListener('click', () => modalAdd.classList.remove('show'));
      modalAdd.addEventListener('click', e => {
        if (e.target === modalAdd) modalAdd.classList.remove('show');
      });

      if (imgInAdd && prevAdd) {
        imgInAdd.addEventListener('change', e => {
          const f = e.target.files[0];
          if (!f) return;
          const reader = new FileReader();
          reader.onload = () => prevAdd.src = reader.result;
          reader.readAsDataURL(f);
        });
      }
      
      
      //
      // ── EDIT MODEL MODAL + PREVIEW ──
      //
      const editBtns   = document.querySelectorAll('.edit-btn');
      const closeEdit  = document.getElementById('closeEdit');
      const modalEdit  = document.getElementById('modalEdit');
      const imgInEdit  = document.getElementById('editImageInput');
      const prevEdit   = document.getElementById('editBannerImg');

      // Open the modal and populate fields
      editBtns.forEach(btn => btn.addEventListener('click', () => {
        // Example of copying server-rendered data-* attributes:
        // document.getElementById('editName').value     = btn.dataset.name;
        // document.getElementById('editCategory').value = btn.dataset.category;

        // Set the existing image from your /uploads folder
        if (prevEdit && btn.dataset.imageFilename) {
          prevEdit.src = `${window.location.origin}${btn.dataset.imageFolder || ''}/uploads/${btn.dataset.imageFilename}`;
        }
        // Clear any previously selected file
        if (imgInEdit) imgInEdit.value = '';

        modalEdit.classList.add('show');
      }));

      // Close handlers
      closeEdit.addEventListener('click', () => modalEdit.classList.remove('show'));
      modalEdit.addEventListener('click', e => {
        if (e.target === modalEdit) modalEdit.classList.remove('show');
      });

      // Live preview of newly chosen file
      if (imgInEdit && prevEdit) {
        imgInEdit.addEventListener('change', e => {
          const file = e.target.files[0];
          if (!file) return;
          const reader = new FileReader();
          reader.onload = () => {
            prevEdit.src = reader.result;
          };
          reader.readAsDataURL(file);
        });
      }

      //
      // ── DELETE CONFIRMATION MODAL ──
      //
      const confirmModal = document.getElementById('confirmDeleteModal');
      const btnYes       = document.getElementById('confirmYes');
      const btnNo        = document.getElementById('confirmNo');
      let deleteUrl      = null;

      document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', e => {
          e.preventDefault();
          deleteUrl = btn.getAttribute('data-delete-url');
          confirmModal.classList.add('show');
        });
      });

      btnYes.addEventListener('click', () => {
        if (deleteUrl) window.location.href = deleteUrl;
      });
      btnNo.addEventListener('click', () => confirmModal.classList.remove('show'));
      confirmModal.addEventListener('click', e => {
        if (e.target === confirmModal) confirmModal.classList.remove('show');
      });
    });
  </script>


</body>
</html>
