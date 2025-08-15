<template>
  <div class="card">
    <div class="card-header d-flex flex-wrap align-items-center justify-content-between gap-3">
      <div class="d-flex flex-wrap align-items-center gap-3">
        <div class="d-flex align-items-center gap-2">
          <span>Show</span>
          <select class="form-select form-select-sm w-auto" v-model="selectedShow">
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="15">15</option>
          </select>
        </div>

        <div class="icon-field">
          <input type="text" class="form-control form-control-sm w-auto" v-model="searchText" placeholder="Search">
          <span class="icon">
            <iconify-icon icon="ion:search-outline"></iconify-icon>
          </span>
        </div>
      </div>

      <div class="d-flex flex-wrap align-items-center gap-3">
        <select class="form-select form-select-sm w-auto" v-model="selectedStatus">
          <option value="">Capacity</option>
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="4">4</option>
          <option value="6">6</option>
        </select>

        <a href="http://localhost:5173/roomType/RoomAdd" class="btn btn-sm btn-primary-600">
          <i class="ri-add-line"></i> Create roomtype
        </a>
      </div>
    </div>

    <!-- Table -->
    <div class="card-body">
      <table class="table bordered-table mb-0">
        <thead>
          <tr>
            <th scope="col" @click="sortBy('id')" style="cursor:pointer; user-select:none;">
              <div class="form-check style-check d-flex align-items-center">
                <input class="form-check-input" type="checkbox" v-model="selectAll" @change="toggleSelectAll">
                <label class="form-check-label d-flex align-items-center gap-1">
                  Id
                  <span :style="{ color: sortKey === 'id' && sortOrder === 1 ? '#2563eb' : '#bbb', fontSize: '12px' }">
                    ▲
                  </span>
                  <span
                    :style="{ color: sortKey === 'id' && sortOrder === -1 ? '#2563eb' : '#bbb', fontSize: '12px', marginLeft: '-2px' }">
                    ▼
                  </span>
                </label>
              </div>
            </th>
            <th scope="col" style="width:100px;">Name</th>
            <th scope="col" @click="sortBy('price')" style="cursor:pointer; user-select:none;">
              Price
              <span
                :style="{ color: sortKey === 'price' && sortOrder === 1 ? '#2563eb' : '#bbb', fontSize: '12px' }">▲</span>
              <span
                :style="{ color: sortKey === 'price' && sortOrder === -1 ? '#2563eb' : '#bbb', fontSize: '12px', marginLeft: '-2px' }">▼</span>
            </th>
            <th scope="col" @click="sortBy('capacity')" style="cursor:pointer; user-select:none;">
              Capacity
              <span
                :style="{ color: sortKey === 'capacity' && sortOrder === 1 ? '#2563eb' : '#bbb', fontSize: '12px' }">▲</span>
              <span
                :style="{ color: sortKey === 'capacity' && sortOrder === -1 ? '#2563eb' : '#bbb', fontSize: '12px', marginLeft: '-2px' }">▼</span>
            </th>
            <th scope="col">Image</th>
            <th scope="col" style="width:220px; text-align:center;">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(room, index) in filteredInvoices" :key="room.id">
            <td>
              <div class="form-check style-check d-flex align-items-center">
                <input class="form-check-input" type="checkbox" v-model="selectedIds" :value="room.id">
                <label class="form-check-label">{{ room.id }}</label>
              </div>
            </td>
            <td style="width:100px;">
              <h6 class="text-md mb-0 fw-medium flex-grow-1">{{ room.name }}</h6>
            </td>
            <td>${{ room.price }} </td>
            <td>
              <span class="px-24 py-4 rounded-pill fw-medium text-sm">
                {{ room.capacity || '-' }}
              </span>
            </td>
            <td>
              <img :src="room.imagePath" alt="" class="flex-shrink-0 radius-8" width="120" height="90">
            </td>
            <td class="text-center text-nowrap" style="vertical-align: middle; width:220px;">
              <router-link :to="`/roomType/RoomPreview/${room.id}`"
                class="w-32-px h-32-px bg-primary-light text-primary-600 rounded-circle d-inline-flex align-items-center justify-content-center mx-1"
                title="Preview">
                <iconify-icon icon="iconamoon:eye-light"></iconify-icon>
              </router-link>
              <router-link :to="`/roomType/RoomEdit/${room.id}`"
                class="w-32-px h-32-px bg-success-focus text-success-main rounded-circle d-inline-flex align-items-center justify-content-center mx-1"
                title="Edit">
                <iconify-icon icon="lucide:edit"></iconify-icon>
              </router-link>
              <a href="#"
                class="w-32-px h-32-px bg-danger-focus text-danger-main rounded-circle d-inline-flex align-items-center justify-content-center mx-1"
                title="Delete"
                @click.prevent="deleteRoom(room.id, index)">
                <iconify-icon icon="mingcute:delete-2-line"></iconify-icon>
              </a>
            </td>
          </tr>
        </tbody>
      </table>
      <!-- Pagination -->
      <div class="pagination d-flex gap-2 justify-content-center mt-4">
        <button :disabled="currentPage === 1" @click="goToPage(1)" class="btn btn-light">&laquo;</button>
        <button v-for="page in totalPages" :key="page"
          :class="['btn', currentPage === page ? 'btn-primary' : 'btn-light']" @click="goToPage(page)">{{ page
          }}</button>
        <button :disabled="currentPage === totalPages" @click="goToPage(totalPages)"
          class="btn btn-light">&raquo;</button>
      </div>
    </div>
  </div>
</template>

<script>
import Pagination from '@/components/pagination/index.vue'
import { roomTypeService } from '@/services/roomTypeService';
import { useToast } from '@/composables/useToast'; // 引入 toast 元件

export default {
  components: { Pagination },
  data() {
    return {
      selectedShow: 10,
      searchText: '',
      selectedStatus: '',
      selectAll: false,
      selectedIds: [],
      currentPage: 1,
      rooms: [],      // 用來存放API資料
      loading: false,
      error: '',
      sortKey: '',
      sortOrder: 1, // 1: 升冪, -1: 降冪
    };
  },
  async mounted() {
    this.loading = true;
    try {
      // 取得資料庫資料
      this.rooms = await roomTypeService.getAllRoomTypes();
      console.log(this.rooms);
    } catch (e) {
      this.error = e.message;
    }
    this.loading = false;
  },
  computed: {
    entriesPerPage() {
      return Number(this.selectedShow);
    },
    filteredData() {
      let result = this.rooms;

      if (this.searchText) {
        const search = this.searchText.toLowerCase();
        result = result.filter(room => {
          const name = room.name ? room.name.toLowerCase() : '';
          const desc = room.description ? room.description.toLowerCase() : '';
          // 搜尋「單」時，排除名稱有「雙」的房型
          if (search === '單') {
            return (
              (name.includes('單') && !name.includes('雙')) ||
              (desc.includes('單') && !desc.includes('雙'))
            );
          }
          // 其他關鍵字維持模糊搜尋
          return name.includes(search) || desc.includes(search);
        });
      }

      if (this.selectedStatus) {
        result = result.filter(room => String(room.capacity) === this.selectedStatus);
      }

      // 排序
      if (this.sortKey) {
        result = result.slice().sort((a, b) => {
          const valA = Number(a[this.sortKey]);
          const valB = Number(b[this.sortKey]);
          if (isNaN(valA) || isNaN(valB)) return 0;
          return (valA - valB) * this.sortOrder;
        });
      }

      return result;
    },
    totalEntries() {
      return this.filteredData.length;
    },
    totalPages() {
      return Math.ceil(this.totalEntries / this.entriesPerPage);
    },
    startIndex() {
      return (this.currentPage - 1) * this.entriesPerPage;
    },
    endIndex() {
      return Math.min(this.startIndex + this.entriesPerPage, this.totalEntries);
    },
    filteredInvoices() {
      return this.filteredData.slice(this.startIndex, this.endIndex);
    }
  },
  watch: {
    selectedShow() {
      this.currentPage = 1;
    },
    searchText() {
      this.currentPage = 1;
    },
    selectedStatus() {
      this.currentPage = 1;
    }
  },
  methods: {
    toggleSelectAll() {
      if (this.selectAll) {
        this.selectedIds = this.filteredInvoices.map(inv => inv.id);
      } else {
        this.selectedIds = [];
      }
    },
    statusClasses(status) {
      return {
        'bg-success-focus text-success-main': status === 'Paid',
        'bg-warning-focus text-warning-main': status === 'Pending'
      };
    },
    goToPage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page;
      }
    },
    changePage(page) {
      this.goToPage(page);
    },
    sortBy(key) {
      if (this.sortKey === key) {
        this.sortOrder = -this.sortOrder;
      } else {
        this.sortKey = key;
        this.sortOrder = 1;
      }
    },
    async deleteRoom(id, index) {
      const { showToast } = useToast();
      if (!confirm('確定要刪除這筆房型嗎？')) return;
      try {
        const success = await roomTypeService.deleteRoomType(id);
        // 從 rooms 移除該筆資料
        this.rooms.splice(this.startIndex + index, 1);

        // 使用 Toast 通知功能
        showToast({
          title: '刪除成功',
          message: `房型 ID: ${id} 已成功刪除`,
          type: 'success',
        });

      } catch (e) {
          showToast({
            title: '刪除失敗 !',
            message: e.message,
            type: 'error',
          });
      }
    }
  }
};
</script>
