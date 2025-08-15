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
                                    <label for="capacity"
                                        class="form-label fw-semibold text-primary-light text-sm mb-8">
                                        Capacity <span class="text-danger-600">*</span>
                                    </label>
                                    <input v-model="form.capacity" type="number" class="form-control radius-8"
                                        id="capacity" placeholder="Enter Capacity" />
                                </div>
                                <div class="mb-20">
                                    <label for="desc" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                        Description
                                    </label>
                                    <textarea v-model="form.description" class="form-control radius-8" id="desc"
                                        placeholder="Write description..."></textarea>
                                </div>
                                <div class="mb-20">
                                    <label for="features"
                                        class="form-label fw-semibold text-primary-light text-sm mb-8">
                                        Special Features
                                    </label>
                                    <textarea v-model="form.features" class="form-control radius-8" id="features"
                                        placeholder="Write special features..."></textarea>
                                </div>

                                <!-- Profile Image 區塊放在表單最下層 -->
                                <div class="mb-24 mt-16">
                                    <h6 class="text-md text-primary-light mb-16">Profile Image</h6>
                                    <div class="avatar-upload" style="width:240px;">
                                        <div class="avatar-preview"
                                            style="position: relative; width:240px; height:180px;">
                                            <div id="imagePreview" class="border border-primary-100" v-bind:style="{
                                                backgroundImage: 'url(' + imagePreview + ')',
                                                borderRadius: '8px',
                                                width: '240px',
                                                height: '180px',
                                                backgroundSize: 'cover',
                                                backgroundPosition: 'center',
                                                boxSizing: 'border-box',
                                                boxShadow: '0 2px 16px #0001'
                                            }"></div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Profile Image End -->

                                <div class="d-flex align-items-center justify-content-center gap-3">
                                    <button type="submit"
                                        class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">
                                        Return to List
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

export default {
    data() {
        return {
            form: {
                name: '',
                price: '',
                capacity: '',
                description: '',
                features: '',
            },
            imagePreview: '',
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
                        features: this.room.special_features || '', // 這裡改成 special_features
                    };
                    this.imagePreview = this.room.imagePath || '';
                }
            } catch (e) {
                this.error = '載入失敗';
            }
            this.loading = false;
        },
        onImageChange(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    this.imagePreview = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        },
        cancelForm() {
            this.$router.push('/roomType/RoomList');
        },
        submitForm() {
            // 你可以在這裡加上儲存邏輯
            // 儲存後導回列表
            this.$router.push('/roomType/RoomList');
        },
        saveForm() {
            // 若有需要可保留
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
    width: 240px;
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
    width: 240px !important;
    height: 180px !important;
}

.avatar-preview #imagePreview {
    border-radius: 8px !important;
    width: 240px !important;
    height: 180px !important;
    position: relative;
    z-index: 2;
    background-color: #fff;
    box-sizing: border-box;
    /* 讓 border 跟預覽圖完全重合 */
}
</style>