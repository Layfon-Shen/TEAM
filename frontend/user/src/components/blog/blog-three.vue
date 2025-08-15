<template>
    <div class="grid md:grid-cols-2 xl:grid-cols-3 gap-7 md:gap-9" data-aos="fade-up" data-aos-delay="100">
        <div v-for="(item, index) in blogData" :key="index" class="group sm:flex items-center">
            <router-link to="#" class="sm:w-1/2 overflow-hidden block">
                <img class="duration-300 transform scale-100 group-hover:scale-110 w-full" :src="item.image" alt="blog-card"/>
            </router-link>
            <div class="bg-snow dark:bg-dark-secondary p-5 md:p-6 sm:ml-[-10%] sm:w-[60%] relative z-10">
                <ul class="flex items-center gap-[10px] flex-wrap">
                    <li class="text-[15px] leading-none dark:text-white">{{item.date}}</li>
                    <li><router-link to="/blog-tag" class="inline-block text-title font-medium text-[15px] leading-none py-2 px-[10px] rounded-md bg-primary-midum">{{item.tag}}</router-link></li>
                </ul>
                <h5 class="mt-3 font-medium text-xl dark:text-white leading-[1.5]"><router-link to="/blog-details-v1" class="text-underline">{{item.title}}</router-link></h5>
            </div>
        </div>
    </div>
</template>

<script setup>
    import { blogData } from '@/data/index-three';
</script>
