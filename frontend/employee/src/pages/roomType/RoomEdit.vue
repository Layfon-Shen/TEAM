<template>
  <div class="card h-100 p-0 radius-12">
    <div class="card-body p-24">
      <div class="row justify-content-center">
        <div class="col-xxl-6 col-xl-8 col-lg-10">
          <div class="card border">
            <div class="card-body">
              <form @submit.prevent="submitForm">
                <div class="mb-20">
                  <label for="name" class="form-label fw-semibold text-primary-light text-sm mb-8">
                    Name <span class="text-danger-600">*</span>
                  </label>
                  <input v-model="form.name" type="text" class="form-control radius-8" id="name"
                    placeholder="Enter Room Name" />
                </div>
                <div class="mb-20">
                  <label for="price" class="form-label fw-semibold text-primary-light text-sm mb-8">
                    Price <span class="text-danger-600">*</span>
                  </label>
                  <input v-model="form.price" type="number" class="form-control radius-8" id="price"
                    placeholder="Enter Price" />
                </div>
                <div class="mb-20">
                  <label for="capacity" class="form-label fw-semibold text-primary-light text-sm mb-8">
                    Capacity <span class="text-danger-600">*</span>
                  </label>
                  <input v-model="form.capacity" type="number" class="form-control radius-8" id="capacity"
                    placeholder="Enter Capacity" />
                </div>
                <div class="mb-20">
                  <label for="desc" class="form-label fw-semibold text-primary-light text-sm mb-8">
                    Description
                  </label>
                  <textarea v-model="form.description" class="form-control radius-8" id="desc"
                    placeholder="Write description..."></textarea>
                </div>
                <div class="mb-20">
                  <label for="features" class="form-label fw-semibold text-primary-light text-sm mb-8">
                    Special Features
                  </label>
                  <textarea v-model="form.features" class="form-control radius-8" id="features"
                    placeholder="Write special features..."></textarea>
                </div>

                <!-- Profile Image 區塊放在表單最下層 -->
                <div class="mb-24 mt-16">
                  <h6 class="text-md text-primary-light mb-16">Profile Image</h6>
                  <div class="avatar-upload" style="width:160px; display: flex; align-items: flex-start;">
                    <div class="avatar-preview" style="position: relative; width:160px; height:120px;">
                      <div id="imagePreview" class="border border-primary-100" v-bind:style="{
                        backgroundImage: 'url(' + imagePreview + ')',
                        borderRadius: '8px',
                        width: '160px',
                        height: '120px',
                        backgroundSize: 'cover',
                        backgroundPosition: 'center',
                        boxSizing: 'border-box',
                        boxShadow: '0 2px 16px #0001'
                      }"></div>
                    </div>
                    <div class="avatar-edit"
                      style="position: static; margin-left: 12px; margin-top: 0; display: flex; align-items: center;">
                      <input type="file" id="imageUpload" ref="imageUpload" accept=".png, .jpg, .jpeg"
                        @change="onImageChange" hidden />
                      <label for="imageUpload"
                        class="w-40-px h-32-px d-flex justify-content-center align-items-center bg-primary-50 text-primary-600 border border-primary-600 bg-hover-primary-100 text-lg"
                        style="border-radius: 8px; width: 40px; height: 32px;">
                        <iconify-icon icon="solar:camera-outline" class="icon"></iconify-icon>
                      </label>
                    </div>
                  </div>
                </div>
                <!-- Profile Image End -->

                <div class="d-flex align-items-center justify-content-center gap-3">
                  <button type="button"
                    class="border border-danger-600 bg-hover-danger-200 text-danger-600 text-md px-56 py-11 radius-8"
                    @click="cancelForm">
                    Cancel
                  </button>
                  <button type="submit" class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">
                    Save
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div>
    <ul>
      <li v-for="room in allRooms" :key="room.id">
        <button @click="selectRoom(room.id)">
          {{ room.name }}
        </button>
      </li>
    </ul>
    <div v-if="selectedRoom">
      <h2>{{ selectedRoom.name }}</h2>
      <p>{{ selectedRoom.description }}</p>
      <!-- 其他房型資訊 -->
    </div>
  </div>
</template>

<script>
import { roomTypeService } from '@/services/roomTypeService';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

export default {
  data() {
    return {
      form: {
        name: '',
        price: '',
        capacity: '',
        description: '',
        features: '',
        image_path: '', // 新增：儲存圖片網址
      },
      originalForm: null, // 新增：儲存原始資料
      imagePreview: '',
      originalImage: '',  // 新增：儲存原始圖片
      loading: false,
      error: '',
      room: null,
    };
  },
  async mounted() {
    await this.fetchRoom();
  },
  watch: {
    '$route.params.id': {
      immediate: true,
      handler() {
        this.fetchRoom();
      }
    }
  },
  methods: {
    async fetchRoom() {
      this.loading = true;
      this.error = '';
      try {
        const id = this.$route.params.id;
        const allRooms = await roomTypeService.getAllRoomTypes();
        this.room = allRooms.find(r => String(r.id) === String(id));
        if (this.room) {
          this.form = {
            name: this.room.name,
            price: this.room.price,
            capacity: this.room.capacity,
            description: this.room.description,
            features: this.room.special_features || '',
            image_path: this.room.imagePath || '', // 預設圖片網址
          };
          this.imagePreview = this.room.imagePath || '';
          // 儲存原始資料
          this.originalForm = { ...this.form };
          this.originalImage = this.imagePreview;
        }
      } catch (e) {
        this.error = '載入失敗';
      }
      this.loading = false;
    },
    // 1. 使用圖片上傳 API，取得網址
    async onImageChange(event) {
      const file = event.target.files[0];
      if (file) {
        // base64 預覽
        const reader = new FileReader();
        reader.onload = (e) => {
          this.imagePreview = e.target.result;
        };
        reader.readAsDataURL(file);
        // 存檔名加上 images/ 前綴
        this.form.image_path = 'images/' + file.name;
      }
    },
    cancelForm() {
      // 恢復原始資料
      this.form = { ...this.originalForm };
      this.imagePreview = this.originalImage;
    },
    // 2. 送出表單時只傳網址
    async submitForm() {
      const { showToast } = useToast();
      this.loading = true;
      try {
        const id = this.$route.params.id;
        // 只組合有變動的欄位
        const updates = {};
        if (this.form.name !== this.originalForm.name) updates.name = this.form.name;
        if (this.form.price !== this.originalForm.price) updates.price = this.form.price;
        if (this.form.capacity !== this.originalForm.capacity) updates.capacity = this.form.capacity;
        if (this.form.description !== this.originalForm.description) updates.description = this.form.description;
        if (this.form.features !== this.originalForm.features) updates.special_features = this.form.features;
        if (this.form.image_path !== this.originalForm.image_path) updates.image_url = this.form.image_path;

        await roomTypeService.patchRoomType(id, updates);
        showToast({
          title: '修改成功',
          message: `修改 ${this.form.name} 成功`,
          type: 'success',
        });
        this.$router.push('/roomType/RoomList');
      } catch (e) {
          showToast({
          title: '修改失敗 !',
          message: e.message,
          type: 'error',
        });
      }
      this.loading = false;
    },
    saveForm() {
      const id = this.$route.params.id;
      // 儲存後清除暫存
      localStorage.removeItem(`roomPreviewForm_${id}`);
      // 這裡可呼叫 API 實際儲存
      alert('已儲存');
    },
    selectRoom(id) {
      this.selectedRoomId = id
    }
  }
};
</script>

<style scoped>
.avatar-upload {
  position: relative;
  width: 160px;
  /* 跟預覽圖一樣寬 */
}

.avatar-edit {
  position: absolute;
  left: 50%;
  bottom: -24px;
  transform: translateX(-50%);
  /* 讓按鈕置中在下方 */
  z-index: 3;
}

.avatar-edit label {
  border-radius: 8px !important;
  width: 40px !important;
  height: 32px !important;
  background: #fff !important;
  border: 1px solid #409eff !important;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px #0001;
  cursor: pointer;
  margin: 0 auto;
  position: relative;
}

.avatar-edit input[type="file"] {
  display: none;
}

.avatar-preview {
  border-radius: 0 !important;
  background: none !important;
  /* 讓 avatar-preview 不要有額外 padding 或 border */
  padding: 0 !important;
  border: none !important;
}

.avatar-preview #imagePreview {
  border-radius: 8px !important;
  width: 160px !important;
  height: 120px !important;
  position: relative;
  z-index: 2;
  background-color: #fff;
  box-sizing: border-box;
  /* 讓 border 跟預覽圖完全重合 */
}
</style>